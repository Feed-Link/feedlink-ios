//
//  RequestProtocol.swift
//  FeedLink
//
//  Created by roshan lamichhane on 12/22/25.
//

import Foundation

protocol RequestProtocol {
    var path: String { get }
    
    var headers: [String: String] { get }
    var params: [String: Any] { get }
    
    var urlParams: [String: String] { get }
    
    var addAuthorizationToken: Bool { get }
    
    var requestType: RequestType { get }
}

extension RequestProtocol {
    var host: String {
        APIConstant.host
    }
    
    var headers: [String: String] {
        [:]
    }
    
    var params: [String: Any] {
        [:]
    }
    
    var urlParams: [String: String] {
        [:]
    }
    
    var addAuthorizationToken: Bool {
        false
    }
    
    func createUrlRequest(authToken: String) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "http"
        components.host = host
        components.path = "/api" + path
        
        if !urlParams.isEmpty {
            components.queryItems = urlParams.map {
                URLQueryItem(name: $0, value: $1)
            }
        }
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue
        
        if !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        if addAuthorizationToken {
            urlRequest.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if !params.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
        }
        
        return urlRequest
    }
}
