//
//  AuthPathOption.swift
//  FeedLink
//
//  Created by roshan lamichhane on 2/8/26.
//

import SwiftUI

enum AuthPathOption: Hashable {
    case login
    case register
    case verification(email: String)
}

struct NavDestForAuthModuleViewModifier: ViewModifier {
    
    @Environment(CoreBuilder.self) var builder
    @Binding var path: [AuthPathOption]
    
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: AuthPathOption.self) { newValue in
                switch newValue {
                case .login:
                    builder.loginView()
                case .register:
                    builder.registerView(path: $path)
                case .verification(let email):
                    builder.verificationView(path: $path, email: email)
                }
            }
    }
}

extension View {
    func navigationDestinationForAuthModule(path: Binding<[AuthPathOption]>) -> some View {
        modifier(NavDestForAuthModuleViewModifier(path: path))
            
    }
}
