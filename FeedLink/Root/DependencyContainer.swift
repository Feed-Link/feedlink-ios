//
//  DependencyContainer.swift
//  FeedLink
//
//  Created by roshan lamichhane on 1/21/26.
//

import SwiftUI

@Observable
@MainActor
class DependencyContainer {
    private var services: [String: Any] = [:]
    
    func register<T>(_ type: T.Type, service: T) {
        let type = "\(type)"
        services[type] = service
    }
    
    func register<T>(_ type: T.Type, service: () -> T) {
        let type = "\(type)"
        services[type] = service()
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        let type = "\(type)"
        return services[type] as? T
    }
}
