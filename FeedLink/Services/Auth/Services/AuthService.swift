//
//  AuthService.swift
//  FeedLink
//
//  Created by roshan lamichhane on 12/23/25.
//

import Foundation

protocol AuthService {
    func login(email: String, password: String) async throws -> AuthResponse
    func register(name: String, email: String, contact: String, password: String, role: String, location: (lat: Double, long: Double)) async throws -> AuthResponse
    func verify(email: String, code: String) async throws -> AuthResponse
    func resendCode(email: String) async throws -> AuthResponse
}
