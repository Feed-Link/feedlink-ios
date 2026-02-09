//
//  RegisterViewModel.swift
//  FeedLink
//
//  Created by roshan lamichhane on 2/6/26.
//

import Observation
import SwiftUI

protocol RegisterInteractor {
    func register(name: String, email: String, contact: String, password: String) async throws -> AuthResponse
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
            try await Task.sleep(for: .seconds(3))
            path.wrappedValue.append(.verification)
//            do {
//                let response = try await interactor.register(name: name, email: email, contact: contact, password: password)
//                guard response.statusCode == 202 else {
//                    showAlert = AnyAppAlert(title: response.message)
//                    return
//                }
//            } catch {
//                showAlert = AnyAppAlert(error: error)
//            }
        }
    }
    
}
