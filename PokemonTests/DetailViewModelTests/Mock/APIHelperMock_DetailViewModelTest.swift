//
//  APIHelperMock_DetailViewModelTest.swift
//  PokemonTests
//
//  Created by Chang Chin-Ming on 2024/3/10.
//

import Foundation
@testable import Pokemon

class APIHelperMock_DetailViewModelTest: APIHelperProtocol {
    
    var expectedData: Data?
    
    func callApi(type: Pokemon.APIHelper.UrlType) async -> Data? {
        return expectedData
    }
    
    func callApi(url: URL) async -> Data? {
        if url.absoluteString == "https://pokeapi.co/api/v2/pokemon-species/1/" {
            let tempStruct = SpeciesData(evolution_chain: UrlData(url: URL(string: "https://pokeapi.co/api/v2/evolution-chain/1/")!),
                                         flavor_text_entries: [SpeciesData.FlavorTextData(flavor_text: "A strange seed was planted on its back at birth.The plant sprouts and grows with this POKéMON.",
                                                                                          language: NameAndUrlData(name: "en",
                                                                                                                   url: URL(string: "https://pokeapi.co/api/v2/language/9/")!))])
            let data = try? JSONEncoder().encode(tempStruct)
            return data
            
        } else if url.absoluteString == "https://pokeapi.co/api/v2/evolution-chain/1/" {
            let evolvesData1 = EvolutionChainsData.EvolvesData(evolves_to: [],
                                                               species: NameAndUrlData(name: "venusaur",
                                                                                       url: URL(string: "https://pokeapi.co/api/v2/pokemon-species/3/")!))
            let evolvesData2 = EvolutionChainsData.EvolvesData(evolves_to: [evolvesData1],
                                                               species: NameAndUrlData(name: "ivysaur",
                                                                                       url: URL(string: "https://pokeapi.co/api/v2/pokemon-species/2/")!))
            let evolvesData3 = EvolutionChainsData.EvolvesData(evolves_to: [evolvesData2],
                                                               species: NameAndUrlData(name: "bulbasaur",
                                                                                       url: URL(string: "https://pokeapi.co/api/v2/pokemon-species/1/")!))
            let tempStruct = EvolutionChainsData(chain: evolvesData3)
            let data = try? JSONEncoder().encode(tempStruct)
            return data
        }
        return expectedData
    }
}
