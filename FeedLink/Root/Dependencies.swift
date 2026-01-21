//
//  Dependencies.swift
//  FeedLink
//
//  Created by roshan lamichhane on 1/21/26.
//

import SwiftUI

@MainActor
struct Dependencies {
    let container: DependencyContainer
    
    let requestManager = RequestManager()
    let authManager: AuthManager
    let appState: AppState
    
    init() {
        self.appState = AppState()
        self.authManager = AuthManager(service: APIAuthService(requestManager: requestManager))
        
        
        let dependencyContainer = DependencyContainer()
        dependencyContainer.register(AppState.self, service: appState)
        dependencyContainer.register(AuthManager.self, service: authManager)
        self.container = dependencyContainer
    }
}

@MainActor
class DevPreview {
    static let shared = DevPreview()
    var container: DependencyContainer {
        let dependencyContainer = DependencyContainer()
        dependencyContainer.register(AppState.self, service: appState)
        dependencyContainer.register(AuthManager.self, service: authManager)
        return dependencyContainer
    }
    
    let appState: AppState
    let authManager: AuthManager
    
    init() {
        self.appState = AppState()
        self.authManager = AuthManager(service: MockAuthService())
    }
}

extension View {
    func previewEnvironment() -> some View {
        self
            .environment(CoreBuilder(interactor: CoreInteractor(container: DevPreview.shared.container)))
    }
}
