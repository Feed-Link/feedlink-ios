//
//  LoginViewModel.swift
//  FeedLink
//
//  Created by roshan lamichhane on 12/24/25.
//

import Observation
import SwiftUI

@MainActor
protocol LoginInteractor {
    func login(email: String, password: String) async throws -> AuthResponse
    func updateViewState(showTabbarView: Bool)
}

extension CoreInteractor: LoginInteractor{}

@MainActor
@Observable
class LoginViewModel {
    let interactor: LoginInteractor
    
    var showAlert: AnyAppAlert?
    private(set) var isLoading: Bool = false
    
    var email = ""
    var password = ""
    
    var path: [AuthPathOption] = []
    
    init(interactor: LoginInteractor) {
        self.interactor = interactor
    }
    
    func login() {
        let validators = [
            CompositeValidator(
                validators: [
                    EmailValidator(),
                    RequiredValidator(fieldName: "Email")
                ]
            ).validate(email),
            RequiredValidator(fieldName: "Password").validate(password)
        ]
        
        guard validators.allSatisfy({$0 == nil}) else {
            showAlert = AnyAppAlert(title: validators.compactMap({$0}).first ?? "Please enter email and password.")
            return
        }
        
        isLoading = true
        
        Task {
            defer {
                isLoading = false
            }
            
            do {
                let response = try await interactor.login(email: email, password: password)
                
                guard response.statusCode == 202 || response.statusCode == 400 else {
                    showAlert = AnyAppAlert(title: response.message)
                    return
                }
                
                if response.statusCode == 400 {
                    path.append(.verification(email: email))
                    return
                }
                guard let accessToken = response.data else {
                    showAlert = AnyAppAlert(title: "Access token not found!")
                    return
                }
                UserDefaults.accessToken = accessToken
                interactor.updateViewState(showTabbarView: true)
                
            } catch {
                showAlert = AnyAppAlert(error: error)
            }
        }
    }
}
