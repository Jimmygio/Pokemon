//
//  PokemonData.swift
//  Pokemon
//
//  Created by Chang Chin-Ming on 2024/3/5.
//

import Foundation

// List API
struct ListData: Codable {
    let count: Int
    let next: URL?
    let previous: URL?
    var results: [NameAndUrlData]
}

struct NameAndUrlData: Codable, Equatable {
    let name: String
    let url: URL
}

struct UrlData: Codable {
    let url: URL
}

// Detail API
struct DetailData: Codable, Equatable {
    let forms: [NameAndUrlData]
    let id: Int
    let types: [TypeData]
    let sprites: SpritesData
    let stats: [StatData]
    let species: NameAndUrlData
    
    struct TypeData: Codable, Equatable {
        let type: NameAndUrlData
    }

    struct SpritesData: Codable, Equatable {
        let front_default: URL
        let front_female: URL?
    }

    struct StatData: Codable, Equatable {
        let base_stat: Int
        let stat: NameAndUrlData
    }

    func frontImageURL() -> URL {
        return sprites.front_default
    }
    
    func frontFemaleImageURL() -> URL? {
        return sprites.front_female
    }

    func nameMessage() -> String? {
        return forms.first?.name.uppercased()
    }
    
    func idMessage() -> String {
        return "ID: \(id)"
    }

    func typesMessage() -> String {
        var type = ""
        types.forEach { typeData in
            if type.isEmpty {
                type += typeData.type.name
            } else {
                type += ", \(typeData.type.name)"
            }
        }
        return "Type(s): \(type)"
    }
    
    func baseStatsMessage() -> String {
        var statStr = ""
        for i in 0..<stats.count {
            statStr += "\(stats[i].stat.name.capitalized): \(stats[i].base_stat)"
            if i != stats.count-1 {
                statStr += "\n"
            }
        }
        return statStr
    }
}

// Species
struct SpeciesData: Codable {
    let evolution_chain: UrlData
    let flavor_text_entries: [FlavorTextData]
    
    struct FlavorTextData: Codable {
        let flavor_text: String
        let language: NameAndUrlData
        
        func flavorTextMessage() -> String {
            return flavor_text.replacingOccurrences(of: "\n", with: "")
        }
    }
}

// Evolution Chain
struct EvolutionChainsData: Codable {
    let chain: EvolvesData
    
    struct EvolvesData: Codable {
        let evolves_to: [EvolvesData]
        let species: NameAndUrlData
    }
}
