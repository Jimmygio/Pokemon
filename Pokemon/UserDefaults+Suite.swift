//
//  UserDefaults+Suite.swift
//  Pokemon
//
//  Created by Chang Chin-Ming on 2024/3/10.
//

import Foundation

let pokemonSuiteName = "group.JimmyChang.Pokemon"

extension UserDefaults {
    
    static var pokemonSuite: UserDefaults {
        return UserDefaults(suiteName: pokemonSuiteName) ?? UserDefaults.standard
    }
}
