//
//  AuthManager.swift
//  FeedLink
//
//  Created by roshan lamichhane on 2/9/26.
//

import Observation

@MainActor
@Observable
class AuthManager {
    
    private let service: AuthService
    
    init(service: AuthService) {
        self.service = service
    }
    
    func login(email: String, password: String) async throws -> AuthResponse {
        return try await service.login(email: email, password: password)
    }
    
    func register(name: String, email: String, contact: String, password: String, role: String, location: (lat: Double, long: Double)) async throws -> AuthResponse {
        return try await service.register(name: name, email: email, contact: contact, password: password, role: role, location: location)
    }
    
    func verify(email: String, code: String) async throws -> AuthResponse {
        try await service.verify(email: email, code: code)
    }
    
    func resendCode(email: String) async throws -> AuthResponse {
        try await service.resendCode(email: email)
    }
}
