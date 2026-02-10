//
//  FoodResponse.swift
//  FeedLink
//
//  Created by roshan lamichhane on 2/10/26.
//

import Foundation

struct FoodsResponse: Codable {
    let message: String
    let statusCode: Int
    let foods: [Food]
    
    enum CodingKeys: String, CodingKey {
        case message
        case statusCode = "statusCode"
        case foods = "data"
    }
}

struct FoodResponse: Codable {
    let statusCode: Int
    let message: String
    let data: Food
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "statusCode"
        case message
        case data
    }
}
