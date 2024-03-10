//
//  URLComponents+Extension.swift
//  Pokemon
//
//  Created by Chang Chin-Ming on 2024/3/6.
//

import Foundation

extension URLComponents {
    
    public var queryParameters: [String: String]? {
        guard let queryItems = self.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
