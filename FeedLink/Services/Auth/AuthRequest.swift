//
//  AuthRequest.swift
//  FeedLink
//
//  Created by roshan lamichhane on 12/22/25.
//

import Foundation

enum AuthRequest: RequestProtocol {
    case login(email: String, password: String)
    case refreshToken
    
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
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
        case .refreshToken:
            return [:]
        }
    }
    
    var requestType: RequestType {
        .POST
    }
}
