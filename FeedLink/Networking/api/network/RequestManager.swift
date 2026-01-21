//
//  RequestManager.swift
//  FeedLink
//
//  Created by roshan lamichhane on 12/22/25.
//

import Foundation

protocol RequestManagerProtocol {
    func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T
}

class RequestManager: RequestManagerProtocol {
    let apiManager: APIManagerProtocol
    let parser: DataParserProtocol
    
    init(
        apiManager: APIManagerProtocol = APIManager(),
        parser: DataParserProtocol = DataParser()
    ) {
        self.apiManager = apiManager
        self.parser = parser
    }
    
    func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T {
        let data = try await apiManager.perform(request, authToken: "")
        let result: T = try parser.parse(data: data)
        return result
    }
    
    func requestRefreshToken() async throws -> String {
        let data = try await apiManager.refreshToken()
        let authResponse: AuthResponse = try parser.parse(data: data)
        return authResponse.data ?? ""
    }
}
