//
//  OwnedHelperMock.swift
//  PokemonTests
//
//  Created by Chang Chin-Ming on 2024/3/9.
//

import Foundation
@testable import Pokemon

class OwnedHelperMock: OwnedHelperProtocol {
    
    var expectedIsOwned: Bool = true
    var expectedOwnedArray = [String]()
    var expectedNameToChnageOwnedStatus: String?

    func isOwned(name: String) async -> Bool {
        return expectedIsOwned
    }
    
    func getOwned() -> [String] {
        return expectedOwnedArray
    }
    
    func changeOwnedStatus(name: String) async {
        expectedNameToChnageOwnedStatus = name.lowercased()
    }
}
