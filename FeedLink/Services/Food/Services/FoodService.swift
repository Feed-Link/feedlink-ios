//
//  FoodService.swift
//  FeedLink
//
//  Created by roshan lamichhane on 2/10/26.
//

import Foundation
import Observation

protocol FoodService {
    func fetchFoods() async throws -> [Food]
}

struct APIFoodService: FoodService {
    private let requestManager: RequestManagerProtocol
    
    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }
    
    func fetchFoods() async throws -> [Food] {
        let requestData = FoodRequest.fetchFoods
        let foodList: FoodsResponse = try await requestManager.perform(requestData)
        return foodList.foods
    }
}

struct MockFoodService: FoodService {
    func fetchFoods() async throws -> [Food] {
        return [
            Food(
                id: "123",
                userId: "1234",
                title: "Daal",
                description: "Daal is Nepali traditional lentil dish",
                type: "doner",
                quantity: 2,
                weight: 0.5,
                pickupWithin: "2026-02-10T12:34:56Z",
                instructions: "Call first",
                address: "Kalanki",
                createdAt: "2026-02-10T12:34:56Z",
                user: User(id: "893", name: "Roshan", email: "me@roshan.engineer", contact: "9812345678", isActive: true)
            )
        ]
    }
}

@Observable
@MainActor
class FoodManager {
    private let service: FoodService
    
    init(service: FoodService) {
        self.service = service
    }
    
    func fetchFoods() async throws -> [Food] {
        try await service.fetchFoods()
    }
}


