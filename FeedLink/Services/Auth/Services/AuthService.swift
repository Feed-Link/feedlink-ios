//
//  AuthService.swift
//  FeedLink
//
//  Created by roshan lamichhane on 12/23/25.
//

import Foundation

protocol AuthService {
    func login(email: String, password: String) async throws -> AuthResponse
    func register(name: String, email: String, contact: String, password: String) async throws -> AuthResponse
}

struct APIAuthService: AuthService {
    
    private let requestManager: RequestManagerProtocol
    
    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }
    
    func login(
        email: String,
        password: String
    ) async throws -> AuthResponse {
        let requestData = AuthRequest.login(email: email, password: password)
        let response: AuthResponse = try await requestManager.perform(requestData)
        return response
    }
    
    func register(
        name: String,
        email: String,
        contact: String,
        password: String
    ) async throws -> AuthResponse {
        let requestData = AuthRequest.register(
            name: name,
            email: email,
            contact: contact,
            password: password
        )
        let response: AuthResponse = try await requestManager.perform(requestData)
        return response
    }
}

struct MockAuthService: AuthService {
    func login(email: String, password: String) async throws -> AuthResponse {
        return AuthResponse(statusCode: 200, message: "Login Success", data: "token")
    }
    
    func register(name: String, email: String, contact: String, password: String) async throws -> AuthResponse {
        return AuthResponse(statusCode: 200, message: "Register success", data: "token")
    }
}


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
    
    func register(name: String, email: String, contact: String, password: String) async throws -> AuthResponse {
        return try await service.register(name: name, email: email, contact: contact, password: password)
    }
    
}
