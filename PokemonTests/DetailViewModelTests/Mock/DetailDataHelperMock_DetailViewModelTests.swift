//
//  DetailDataHelperMock_DetailViewModelTests.swift
//  PokemonTests
//
//  Created by Chang Chin-Ming on 2024/3/10.
//

import Foundation
@testable import Pokemon

class DetailDataHelperMock_DetailViewModelTests: DetailDataHelperProtocol {
    
    var detailData1: DetailData?
    var detailData2: DetailData?
    var detailData3: DetailData?

    func loadDetailData(data: NameAndUrlData) async -> DetailData? {
        if data.name == "bulbasaur" {
            return detailData1
        } else if data.name == "ivysaur" {
            return detailData2
        } else if data.name == "venusaur" {
            return detailData3
        }
        return nil
    }
}
