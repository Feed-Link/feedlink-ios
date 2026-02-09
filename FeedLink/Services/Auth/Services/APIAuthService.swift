//
//  APIAuthService.swift
//  FeedLink
//
//  Created by roshan lamichhane on 2/9/26.
//

import Foundation

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
        password: String,
        role: String,
        location: (lat: Double, long: Double)
    ) async throws -> AuthResponse {
        let requestData = AuthRequest.register(
            name: name,
            email: email,
            contact: contact,
            password: password,
            role: role,
            location: location
        )
        let response: AuthResponse = try await requestManager.perform(requestData)
        return response
    }
    
    func verify(email: String, code: String) async throws -> AuthResponse {
        let requestData = AuthRequest.verifyOTP(email: email, code: code)
        let response: AuthResponse = try await requestManager.perform(requestData)
        return response
    }
    
    func resendCode(email: String) async throws -> AuthResponse {
        let requestData = AuthRequest.resendOTP(email: email)
        let response: AuthResponse = try await requestManager.perform(requestData)
        return response
    }
}
