//
//  UserDefaultKey.swift
//  Pokemon
//
//  Created by Chang Chin-Ming on 2024/3/6.
//

import Foundation

enum UserDefaultKey: String {
    case detailData = "detailData"
    case ownedPokemons = "ownedPokemons"
    
    func addSuffix(name: String) -> String {
        return "\(self.rawValue)_\(name)"
    }
}
