//
//  FoodRequest.swift
//  FeedLink
//
//  Created by roshan lamichhane on 2/10/26.
//

import Foundation

enum FoodRequest: RequestProtocol {
    case fetchFoods
    case fetchFoodBy(id: UUID)
    case deleteFoodBy(id: UUID)
    
    var path: String {
        "/foodlist"
    }
    
    var params: [String : Any] {
        switch self {
        case .fetchFoods:
            return [:]
        case .fetchFoodBy(id: let id):
            let params: [String: Any] = ["id": id]
            return params
        case .deleteFoodBy(id: let id):
            let params: [String: Any] = ["id": id]
            return params
        }
    }
    
    var requestType: RequestType {
        switch self {
        case .fetchFoods:
                .GET
        case .fetchFoodBy:
                .GET
        case .deleteFoodBy:
                .DELETE
        }
    }
    
    var headers: [String : String] {
        ["Accept": "application/json"]
    }
    
    var addAuthorizationToken: Bool {
        true
    }
}
