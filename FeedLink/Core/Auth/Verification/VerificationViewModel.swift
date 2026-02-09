//
//  VerificationViewModel.swift
//  FeedLink
//
//  Created by roshan lamichhane on 2/9/26.
//

import Observation
import SwiftUI

@MainActor
protocol VerificationInteractor {
    func verify(email: String, code: String) async throws -> AuthResponse
    func resendCode(email: String) async throws -> AuthResponse
    func updateViewState(showTabbarView: Bool)
}

extension CoreInteractor: VerificationInteractor {}

@MainActor
@Observable
class VerificationViewModel {
    private let interactor: VerificationInteractor

    var verificationCode: String = ""
    var showAlert: AnyAppAlert?
    private(set) var isLoading: Bool = false

    private(set) var resendRemaining: Int = 0
    private var resendTask: Task<Void, Never>?

    init(interactor: VerificationInteractor) {
        self.interactor = interactor
    }

    var canResend: Bool {
        resendRemaining == 0
    }

    func startResendTimer(seconds: Int = 60) {
        resendTask?.cancel()
        resendRemaining = seconds
        resendTask = Task { [weak self] in
            guard let self else { return }
            while self.resendRemaining > 0 {
                try? await Task.sleep(for: .seconds(1))
                self.resendRemaining -= 1
            }
        }
    }

    func resendCode(email: String) {
        showAlert = nil
        startResendTimer()
        Task {
            do {
                let response = try await interactor.resendCode(email: email)
                guard response.statusCode ==  201 else {
                    showAlert = AnyAppAlert(title: response.message)
                    return
                }
            } catch {
                showAlert = AnyAppAlert(error: error)
            }
        }
    }

    func verify(email: String, path: Binding<[AuthPathOption]>) {
        
        let validators = [
            CompositeValidator(
                validators: [
                    RequiredValidator(fieldName: "Verification code"),
                    OTPValidator()
                ]
            ).validate(verificationCode)
        ]
        
        guard validators.allSatisfy({$0 == nil}) else {
            showAlert = AnyAppAlert(title: validators.compactMap({$0}).first ?? "Please enter valid verification code and try again.")
            return
        }
        
        isLoading = true

        Task { [weak self] in
            guard let self else { return }
            defer { self.isLoading = false }
            do {
                let response = try await self.interactor.verify(email: email, code: verificationCode)
                guard response.statusCode == 200 else {
                    showAlert = AnyAppAlert(title: response.message)
                    return
                }
                interactor.updateViewState(showTabbarView: true)
            } catch {
                showAlert = AnyAppAlert(title: "Failed to verify code. Please try again.")
            }
        }
    }
}
