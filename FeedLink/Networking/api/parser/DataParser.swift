//
//  DataParser.swift
//  FeedLink
//
//  Created by roshan lamichhane on 12/22/25.
//

import Foundation

protocol DataParserProtocol {
    func parse<T: Decodable>(data: Data) throws -> T
}

class DataParser: DataParserProtocol {
    private var jsonDecoder: JSONDecoder
    
    init(jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.jsonDecoder = jsonDecoder
//        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func parse<T>(data: Data) throws -> T where T : Decodable {
        return try jsonDecoder.decode(T.self, from: data)
    }
}
