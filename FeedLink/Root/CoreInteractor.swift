//
//  CoreInteractor.swift
//  FeedLink
//
//  Created by roshan lamichhane on 1/21/26.
//

import Foundation

@MainActor
struct CoreInteractor {
    private let appState: AppState
    private let authManager: AuthManager
    private let foodManager: FoodManager
    
    init(container: DependencyContainer) {
        self.authManager = container.resolve(AuthManager.self)!
        self.appState = container.resolve(AppState.self)!
        self.foodManager = container.resolve(FoodManager.self)!
    }
    
    // MARK: - AppState
    
    var showTabBar: Bool {
        appState.showTabBar
    }
    
    func updateViewState(showTabbarView: Bool) {
        appState.updateViewState(showTabbarView: showTabbarView)
    }
    
    // MARK: - Auth Manager
    func login(email: String, password: String) async throws -> AuthResponse {
        try await authManager.login(email: email, password: password)
    }
    
    func register(name: String, email: String, contact: String, password: String, role: String, location: (lat: Double, long: Double)) async throws -> AuthResponse {
        try await authManager.register(name: name, email: email, contact: contact, password: password, role: role, location: location)
    }
    
    func verify(email: String, code: String) async throws -> AuthResponse {
        try await authManager.verify(email: email, code: code)
    }
    
    func resendCode(email: String) async throws -> AuthResponse {
        try await authManager.resendCode(email: email)
    }
    
    // MARK: - Food Manager
    func fetchFoods() async throws -> [Food] {
        try await foodManager.fetchFoods()
    }
}
