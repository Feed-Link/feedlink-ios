//
//  APIManager.swift
//  FeedLink
//
//  Created by roshan lamichhane on 12/22/25.
//

import Foundation

protocol APIManagerProtocol {
    func perform(_ request: RequestProtocol, authToken: String) async throws -> Data
    func refreshToken() async throws -> Data
}

class APIManager: APIManagerProtocol {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func perform(_ request: any RequestProtocol, authToken: String) async throws -> Data {
        let (data, response) = try await urlSession.data(for: request.createUrlRequest(authToken: authToken))
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            if let jsonObj = try? JSONSerialization.jsonObject(with: data), let prettyData = try? JSONSerialization.data(withJSONObject: jsonObj, options: .prettyPrinted), let jsonString = String(data: prettyData, encoding: .utf8) {
                print("ERROR Response For - \(request.path): \n\(jsonString)")
            }
            throw NetworkError.invalidServerResponse
        }
        
        // String json
        if let jsonObject = try? JSONSerialization.jsonObject(with: data), let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted), let jsonString = String(data: prettyData, encoding: .utf8) {
            print("JSON Response For - \(request.path): \n\(jsonString)")
        }
        
        return data
    }
    
    func refreshToken() async throws -> Data {
        try await perform(AuthRequest.refreshToken, authToken: "")
    }
}
