//
//  APIHelperMock.swift
//  PokemonTests
//
//  Created by Chang Chin-Ming on 2024/3/9.
//

import Foundation
@testable import Pokemon

class APIHelperMock: APIHelperProtocol {
    
    var expectedData: Data?
    
    func callApi(type: Pokemon.APIHelper.UrlType) async -> Data? {
        return expectedData
    }
    
    func callApi(url: URL) async -> Data? {
        return expectedData
    }
}
