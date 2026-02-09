//
//  LoginView.swift
//  FeedLink
//
//  Created by roshan lamichhane on 12/23/25.
//

import SwiftUI

struct LoginView: View {
    @State var viewModel: LoginViewModel
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            VStack(spacing: 24) {
                
                FormField(
                    label: "Email",
                    placeholder: "Your email",
                    text: $viewModel.email,
                    validator: CompositeValidator(
                        validators: [
                            EmailValidator(),
                            RequiredValidator(fieldName: "Email")
                        ]
                    ),
                    keyboardType: .emailAddress,
                    autocapitalization: .never,
                )
                
                FormField(
                    label: "Password",
                    placeholder: "Your password",
                    text: $viewModel.password,
                    validator: RequiredValidator(fieldName: "Password"),
                    isSecure: true,
                )
                
                loginCTA
                
                Text("Sign up")
                    .callToActionButton()
                    .anyButton {
                        viewModel.path.append(.register)
                    }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
            .showCustomAlert(alert: $viewModel.showAlert)
            .navigationDestinationForAuthModule(path: $viewModel.path)
        }
    }
    
    var loginCTA: some View {
        AsyncCallToActionButton(
            isLoading: viewModel.isLoading,
            title: "Sign In"
        ) {
            viewModel.login()
        }
    }
}

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color.blue, Color.purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 4)
        }
    }
}

#Preview {
    let container = DevPreview.shared.container
    let interactor = CoreInteractor(container: container)
    let coreBuilder = CoreBuilder(interactor: interactor)
    
    coreBuilder.loginView()
        .previewEnvironment()
}
