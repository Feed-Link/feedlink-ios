//
//  User.swift
//  FeedLink
//
//  Created by roshan lamichhane on 2/10/26.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let email: String
    let contact: String
    let isActive: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case contact
        case isActive = "is_active"
    }
}
