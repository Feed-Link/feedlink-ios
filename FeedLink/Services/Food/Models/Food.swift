//
//  Food.swift
//  FeedLink
//
//  Created by roshan lamichhane on 2/10/26.
//

import Foundation

struct Food: Codable, Identifiable {
    let id: String
    let userId: String
    let title: String
    let description: String
    let type: String
    let quantity: Int
    let weight: Double
    let pickupWithin: String
    let instructions: String
    let address: String
    let createdAt: String
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case title
        case description
        case type
        case quantity
        case weight
        case pickupWithin = "pickup_within"
        case instructions
        case address
        case createdAt = "created_at"
        case user
    }
}

