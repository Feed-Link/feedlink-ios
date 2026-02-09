//
//  AuthRequest.swift
//  FeedLink
//
//  Created by roshan lamichhane on 12/22/25.
//

import Foundation

enum AuthRequest: RequestProtocol {
    case login(email: String, password: String)
    case register(name: String, email: String, contact: String, password: String, role: String, location: (lat: Double, long: Double))
    case verifyOTP(email: String, code: String)
    case resendOTP(email: String)
    case refreshToken
    
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .register:
            return "/auth/register"
        case .verifyOTP:
            return "/auth/verify-otp"
        case .resendOTP:
            return "/auth/resend-otp"
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
        case .register(name: let name, email: let email, contact: let contact, password: let password, let role, let location):
            var params: [String: Any] = [:]
            params["name"] = name
            params["email"] = email
            params["contact"] = contact
            params["password"] = password
            params["role"] = role
            params["location"] = [
                "lat": location.lat,
                "long": location.long
            ]
            return params
        case .verifyOTP(email: let email, code: let code):
            let params = [
                "email": email,
                "otp": code
            ]
            return params
        case .resendOTP(email: let email):
            let params = ["email": email]
            return params
        case .refreshToken:
            return [:]
        }
    }
    
    var requestType: RequestType {
        .POST
    }
}
