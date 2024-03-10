//
//  DetailViewModel.swift
//  Pokemon
//
//  Created by Chang Chin-Ming on 2024/3/7.
//

import Foundation

protocol DetailViewModelProtocol {
    var detailData: DetailData? { get set }
    
    func loadDescriptionAndEvolution(descriptionCompletion: @escaping StringCompletion, evolutionCompletion: @escaping DetailDatasCompletion)
    func isOwned() async -> Bool
    func changeOwnedStatus() async
}

class DetailViewModel: DetailViewModelProtocol {
    
    var detailData: DetailData?
    
    private let apiHelper: APIHelperProtocol
    private let ownedHelper: OwnedHelperProtocol
    private let detailDataHelper: DetailDataHelperProtocol
    
    init(apiHelper: APIHelperProtocol = APIHelper(),
         ownedHelper: OwnedHelperProtocol = OwnedHelper(),
         detailDataHelper: DetailDataHelperProtocol = DetailDataHelper()) {
        self.apiHelper = apiHelper
        self.ownedHelper = ownedHelper
        self.detailDataHelper = detailDataHelper
    }
}
 
// MARK: - Description Text Data
extension DetailViewModel {

    func loadDescriptionAndEvolution(descriptionCompletion: @escaping StringCompletion, evolutionCompletion: @escaping DetailDatasCompletion) {
        Task {
            guard let detailData = detailData else { return }
            
            if let tempData = await self.apiHelper.callApi(url: detailData.species.url) {
                do {
                    let speciesData = try JSONDecoder().decode(SpeciesData.self, from: tempData)
                    let flavorTexts = speciesData.flavor_text_entries

                    // Description
                    let languageCode = isTraditionalChinese() ? LanguageCode.traditionalChinese.rawValue: LanguageCode.english.rawValue
                    let flavorText = flavorTexts.first()  {
                        $0.language.name == languageCode
                    }
                    descriptionCompletion(flavorText?.flavorTextMessage() ?? "")
                    
                    // Evolution
                    getEvolution(url: speciesData.evolution_chain.url, evolutionCompletion: evolutionCompletion)
                    
                } catch {
                    print("loadDescriptionAndEvolution tempData = \(tempData), error = \(error)" )
                }
            }
        }
    }
}

// MARK: - Evolution Data
extension DetailViewModel {

    private func getEvolution(url: URL, evolutionCompletion: @escaping DetailDatasCompletion) {
        Task {
            if let tempData = await self.apiHelper.callApi(url: url) {
                do {
                    let data = try JSONDecoder().decode(EvolutionChainsData.self, from: tempData).chain
                    loopToFindEvolutions(data: data, detailDatas: [DetailData](), evolutionCompletion: evolutionCompletion)
                    
                } catch {
                    print("getEvolution tempData = \(tempData), error = \(error)" )
                }
            }
        }
    }
    
    private func loopToFindEvolutions(data: EvolutionChainsData.EvolvesData, detailDatas: [DetailData], evolutionCompletion: @escaping DetailDatasCompletion) {
        Task {
            guard let url = URL(string: APIHelper.UrlType.list.rawValue + "/" + data.species.name) else { return }
            
            var detailDatas = detailDatas
            let nameAndUrlData = NameAndUrlData(name: data.species.name, url: url)
            if let loadedData = await self.detailDataHelper.loadDetailData(data: nameAndUrlData) {
                detailDatas.append(loadedData)
            }
            if data.evolves_to.count > 0,
               let data2 = data.evolves_to.first {
                loopToFindEvolutions(data: data2, detailDatas: detailDatas, evolutionCompletion: evolutionCompletion)
            } else {
                evolutionCompletion(detailDatas)
            }
        }
    }
}


// MARK: - Owned Data
extension DetailViewModel {
    
    func isOwned() async -> Bool {
        if let name = detailData?.nameMessage() {
            return await ownedHelper.isOwned(name: name)
        }
        return false
    }
    
    func changeOwnedStatus() async {
        if let name = detailData?.nameMessage() {
            await ownedHelper.changeOwnedStatus(name: name)
        }
    }
}
