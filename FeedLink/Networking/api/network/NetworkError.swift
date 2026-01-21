//
//  NetworkError.swift
//  FeedLink
//
//  Created by roshan lamichhane on 12/22/25.
//

import Foundation

public enum NetworkError: LocalizedError {
    case invalidServerResponse
    case invalidURL
    
    public var errorDescription: String? {
        switch self {
        case .invalidServerResponse:
            "The server returned an invalid response."
        case .invalidURL:
            "URL string is malformed."
        }
    }
}
