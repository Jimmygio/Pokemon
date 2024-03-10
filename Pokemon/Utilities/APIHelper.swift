//
//  APIHelper.swift
//  Pokemon
//
//  Created by Chang Chin-Ming on 2024/3/5.
//

import Foundation

protocol APIHelperProtocol {
    func callApi(type: APIHelper.UrlType) async -> Data?
    func callApi(url: URL) async -> Data?
}

actor APIHelper: APIHelperProtocol {    
    
    enum UrlType: String {
        case list = "https://pokeapi.co/api/v2/pokemon"
    }

    func callApi(type: UrlType) async -> Data? {
        guard let url = URL(string: type.rawValue) else {
            return nil
        }
        return await callApi(url: url)
    }
    
    func callApi(url: URL) async -> Data? {
        do {
            let request = URLRequest(url: url)
            let (data, _) = try await URLSession.shared.data(for: request)
            return data
            
        } catch {
            print("callApi url = \(url), error = \(error)" )
            return nil
        }
    }
}
