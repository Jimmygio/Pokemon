//
//  DetailDataHelper.swift
//  Pokemon
//
//  Created by Chang Chin-Ming on 2024/3/9.
//

import Foundation

protocol DetailDataHelperProtocol {
    func loadDetailData(data: NameAndUrlData) async -> DetailData?
}

class DetailDataHelper: DetailDataHelperProtocol {
    
    private let apiHelper: APIHelperProtocol
    private let userDefault: UserDefaults
    private var detailData: DetailData?
    
    init(apiHelper: APIHelperProtocol = APIHelper(),
         userDefault: UserDefaults = UserDefaults.pokemonSuite) {
        self.apiHelper = apiHelper
        self.userDefault = userDefault
    }
    
    func loadDetailData(data: NameAndUrlData) async -> DetailData? {
        var tempData: Data?
        let key = UserDefaultKey.detailData.addSuffix(name: data.name)
        let decoder = JSONDecoder()
        // 有未過期的Cache資料就先用
        if let cachedData = loadCachedData(dataKey: key) {
            tempData = cachedData
            // 不然從API抓
        } else {
            tempData = await apiHelper.callApi(url: data.url)
            saveCachedData(data: tempData, dataKey: key)
        }
        if let tempData = tempData {
            do {
                detailData = try decoder.decode(DetailData.self, from: tempData)
                return detailData
                
            } catch {
                print("loadDetailData data = \(data), tempData = \(tempData), error = \(error)" )
                return nil
            }
        }
        return nil
    }
    
    private func dateKey(_ dataKey: String) -> String {
        return "\(dataKey)_Date"
    }
    
    private func saveCachedData(data: Data?, dataKey: String) {
        if let data = data {
            userDefault.setValue(data, forKey: dataKey)
            userDefault.set(Date(), forKey: dateKey(dataKey))
        } else {
            userDefault.removeObject(forKey: dataKey)
            userDefault.removeObject(forKey: dateKey(dataKey))
        }
    }
    
    private func loadCachedData(dataKey: String) -> Data? {
        // 超過一定時間刪除Cache資料，這邊預設一天
        if let date = userDefault.object(forKey: dateKey(dataKey)) as? Date,
           let diff = Calendar.current.dateComponents([.day], from: date, to: Date()).day,
           diff >= 1 {
            saveCachedData(data: nil, dataKey: dataKey)
            return nil
        }
        return userDefault.data(forKey: dataKey)
    }
}
