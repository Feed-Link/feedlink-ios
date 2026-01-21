//
//  AuthResponse.swift
//  FeedLink
//
//  Created by roshan lamichhane on 12/22/25.
//

struct AuthResponse: Codable {
    let statusCode: Int
    let message: String
    let data: String?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "statusCode"
        case message
        case data
    }
    
}
