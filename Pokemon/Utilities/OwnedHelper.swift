//
//  OwnedHelper.swift
//  Pokemon
//
//  Created by Chang Chin-Ming on 2024/3/8.
//

import Foundation

protocol OwnedHelperProtocol {
    func isOwned(name: String) async -> Bool
    func getOwned() -> [String]
    func changeOwnedStatus(name: String) async
}

class OwnedHelper: OwnedHelperProtocol {
    
    private let userDefault: UserDefaults

    init(userDefault: UserDefaults =  UserDefaults.pokemonSuite) {
        self.userDefault = userDefault
    }
    
    func isOwned(name: String) -> Bool {
        let name = name.lowercased()
        return getOwned().contains(name)
    }
    
    func getOwned() -> [String] {
        if let ownedPokemons = userDefault.object(forKey: UserDefaultKey.ownedPokemons.rawValue) as? [String] {
            return ownedPokemons
        } else {
            let ownedPokemons = [String]()
            userDefault.set(ownedPokemons, forKey: UserDefaultKey.ownedPokemons.rawValue)
            return ownedPokemons
        }
    }
    
    func changeOwnedStatus(name: String) {
        let name = name.lowercased()
        var ownedPokemons = getOwned()
        if ownedPokemons.contains(name) {
            ownedPokemons.removeAll {
                $0 == name
            }
        } else {
            ownedPokemons.append(name)
        }
        userDefault.set(ownedPokemons, forKey: UserDefaultKey.ownedPokemons.rawValue)
        print("changeOwnedStatus ownedPokemons = \(ownedPokemons)")
    }
}
