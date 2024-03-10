//
//  CollectionViewCellViewModel.swift
//  Pokemon
//
//  Created by Chang Chin-Ming on 2024/3/5.
//

import Foundation

protocol CollectionViewCellViewModePprotocol {
    func loadDetailData(data: NameAndUrlData) async -> DetailData?
}

class CollectionViewCellViewModel: CollectionViewCellViewModePprotocol {
    
    private let detailDataHelper: DetailDataHelperProtocol
    
    init(detailDataHelper: DetailDataHelperProtocol = DetailDataHelper()) {
        self.detailDataHelper = detailDataHelper
    }
    
    func loadDetailData(data: NameAndUrlData) async -> DetailData? {
        return await detailDataHelper.loadDetailData(data: data)
    }
}
