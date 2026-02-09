//
//  MockAuthService.swift
//  FeedLink
//
//  Created by roshan lamichhane on 2/9/26.
//

import Foundation

struct MockAuthService: AuthService {
    func login(email: String, password: String) async throws -> AuthResponse {
        return AuthResponse(statusCode: 200, message: "Login Success", data: "token")
    }
    
    func register(name: String, email: String, contact: String, password: String, role: String, location: (lat: Double, long: Double)) async throws -> AuthResponse {
        return AuthResponse(statusCode: 200, message: "Register success", data: "token")
    }
    
    func verify(email: String, code: String) async throws -> AuthResponse {
        return AuthResponse(statusCode: 200, message: "Verification success", data: "Might be token")
    }
    
    func resendCode(email: String) async throws -> AuthResponse {
        return AuthResponse(statusCode: 200, message: "Code sent", data: nil)
    }
}
