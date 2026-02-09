//
//  LoginView.swift
//  FeedLink
//
//  Created by roshan lamichhane on 12/23/25.
//

import SwiftUI

struct LoginView: View {
    @State var viewModel: LoginViewModel
    @State private var path: [AuthPathOption] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.secondary)
                    
                    TextField("", text: $viewModel.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.3)))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.secondary)
                    
                    SecureField("", text: $viewModel.password)
                        .textContentType(.password)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.3)))
                }
                
                loginCTA
                
                Text("Sign up")
                    .callToActionButton()
                    .anyButton {
                        path.append(.register)
                    }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
            .showCustomAlert(alert: $viewModel.showAlert)
            .navigationDestinationForAuthModule(path: $path)
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
