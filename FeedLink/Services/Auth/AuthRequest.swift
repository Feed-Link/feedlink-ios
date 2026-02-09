//
//  AuthRequest.swift
//  FeedLink
//
//  Created by roshan lamichhane on 12/22/25.
//

import Foundation

enum AuthRequest: RequestProtocol {
    case login(email: String, password: String)
    case register(name: String, email: String, contact: String, password: String)
    case refreshToken
    
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .register:
            return "/auth/register"
        case .refreshToken:
            return "/auth/refresh"
        }
    }
    
    var params: [String : Any] {
        switch self {
        case .login(email: let email, password: let password):
            var params = ["email": email]
            params["password"] = password
            return params
        case .register(name: let name, email: let email, contact: let contact, password: let password):
            var params = ["name": name]
            params["email"] = email
            params["contact"] = contact
            params["password"] = password
            return params
        case .refreshToken:
            return [:]
        }
    }
    
    var requestType: RequestType {
        .POST
    }
}
