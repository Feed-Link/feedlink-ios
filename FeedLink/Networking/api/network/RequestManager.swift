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
        let authToken = try await requestAccessToken()
        let data = try await apiManager.perform(request, authToken: authToken)
        let result: T = try parser.parse(data: data)
        return result
    }
    
    func requestAccessToken() async throws -> String {
        UserDefaults.accessToken
    }
}
