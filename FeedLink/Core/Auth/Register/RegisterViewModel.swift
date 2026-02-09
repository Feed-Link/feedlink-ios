//
//  RegisterViewModel.swift
//  FeedLink
//
//  Created by roshan lamichhane on 2/6/26.
//

import Observation
import SwiftUI

@MainActor
protocol RegisterInteractor {
    func register(name: String, email: String, contact: String, password: String, role: String, location: (lat: Double, long: Double)) async throws -> AuthResponse
}

extension CoreInteractor: RegisterInteractor {}

@Observable
@MainActor
class RegisterViewModel {
    let interactor: RegisterInteractor
    
    var showAlert: AnyAppAlert?
    private(set) var isLoading: Bool = false
    
    var name: String = ""
    var email: String = ""
    var contact: String = ""
    var password: String = ""
    var role: UserRole?
    
    init(interactor: RegisterInteractor) {
        self.interactor = interactor
    }
    
    func register(path: Binding<[AuthPathOption]>) {
        let validators = [
            RequiredValidator(fieldName: "Name").validate(name),
            CompositeValidator(
                validators: [
                    RequiredValidator(fieldName: "Email"),
                    EmailValidator(),
                    
                ]
            ).validate(email),
            RequiredValidator(fieldName: "Contact").validate(contact),
            CompositeValidator(
                validators: [
                    RequiredValidator(fieldName: "Password"),
                    MinLengthValidator(minLength: 6, fieldName: "Password"),
                ]
            ).validate(password),
            SelectionRequiredValidator(fieldName: "Role").validate(role?.rawValue ?? "")
        ]
        
        guard validators.allSatisfy({ $0 == nil}) else {
            showAlert = AnyAppAlert(title: validators.compactMap({$0}).first ?? "Please fill all the fields")
            return
        }
        
        isLoading = true
        
        Task {
            defer { isLoading = false }
            do {
                guard let role = role else { return }
                let response = try await interactor.register(name: name, email: email, contact: contact, password: password, role: role.rawValue, location: (lat: 27.7103, long: 85.3222))
                guard response.statusCode == 201 else {
                    showAlert = AnyAppAlert(title: response.message)
                    return
                }
                path.wrappedValue.append(.verification(email: email))
            } catch {
                showAlert = AnyAppAlert(error: error)
            }
        }
    }
    
}
