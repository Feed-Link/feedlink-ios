//
//  LoginViewModel.swift
//  FeedLink
//
//  Created by roshan lamichhane on 12/24/25.
//

import SwiftUI

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
    var alertMessage: String?
    
    var email = ""
    var password = ""
    
    init(interactor: LoginInteractor) {
        self.interactor = interactor
    }
    
    func login() {
        
        if email.isEmpty || password.isEmpty {
            showAlert = AnyAppAlert(title: "Email and password cannot be empty")
            return
        }
        
        Task {
            do {
                let response = try await interactor.login(email: email, password: password)
                if response.statusCode != 202 {
                    showAlert = AnyAppAlert(title: response.message)
                    return
                }
                interactor.updateViewState(showTabbarView: true)
            } catch {
                showAlert = AnyAppAlert(error: error)
            }
        }
    }
}
