//
//  HomeViewModel.swift
//  Pokemon
//
//  Created by Chang Chin-Ming on 2024/3/5.
//

import Foundation

protocol HomeViewModelProtocol {
    var showedDatas: [NameAndUrlData] { get }
    var updateUIClosure: NormalCompletion? { get set }
    var lockOwnedButtonClosure: BoolCompletion? { get set }

    func loadPokemonList()
    func changeOwnedMode() -> HomeViewModel.OwnedMode
    func checkIfNeedloadNextPage(row: Int)
}

class HomeViewModel: HomeViewModelProtocol {
 
    private let apiHelper: APIHelperProtocol
    private let ownedHelper: OwnedHelperProtocol
    private var listData: ListData = ListData(count: 0, next: nil, previous: nil, results: [NameAndUrlData]())
    var showedDatas = [NameAndUrlData]()
    var updateUIClosure: NormalCompletion?
    var lockOwnedButtonClosure: BoolCompletion?
    private var currentApiUrl: URL?
    private let lastestID = 1025
    
    enum OwnedMode {
        case disable
        case enable
    }
    private var ownedMode: OwnedMode = .disable
    
    init(apiHelper: APIHelperProtocol = APIHelper(),
         ownedHelper: OwnedHelperProtocol = OwnedHelper()) {
        self.apiHelper = apiHelper
        self.ownedHelper = ownedHelper
    }
    
    @MainActor
    func loadPokemonList() {
        guard let url = URL(string: APIHelper.UrlType.list.rawValue) else {
            return
        }
        loadPokemonList(url: url)
    }
    
    @MainActor
    private func loadPokemonList(url: URL) {
        Task {
            currentApiUrl = url
//            print("currentApiUrl = \(String(describing: currentApiUrl))")
            lockOwnedButtonClosure?(true)
            if let tempData = await self.apiHelper.callApi(url: url) {
                lockOwnedButtonClosure?(false)
                currentApiUrl = nil
                do {
                    let newListData = try JSONDecoder().decode(ListData.self, from: tempData)
                    showedDatas = listData.results + newListData.results
                    listData = newListData
                    listData.results = showedDatas
                    updateUIClosure?()

                } catch {
                    print("loadPokemonList, error = \(error)" )
                }
            }
        }
    }
    
    func changeOwnedMode() -> OwnedMode {
        switch ownedMode {
        case .disable:
            ownedMode = .enable
            var tempArray = [NameAndUrlData]()
            let ownedArray = ownedHelper.getOwned()
            for i in 0..<ownedArray.count {
                let data = showedDatas.first {
                    $0.name == ownedArray[i]
                }
                if let data = data {
                    tempArray.append(data)
                }
            }
            showedDatas = tempArray
            updateUIClosure?()

        case .enable:
            ownedMode = .disable
            showedDatas = listData.results
            updateUIClosure?()
        }
        return ownedMode
    }
    
    @MainActor
    func checkIfNeedloadNextPage(row: Int) {
        if ownedMode == .disable,
           showedDatas.count < lastestID,
           row+5 == showedDatas.count,
           var nextUrl = listData.next,
           nextUrl != currentApiUrl {
            // 限制不要超過最後的ID
            if var urlComponents = URLComponents(url: nextUrl, resolvingAgainstBaseURL: true),
               var queryParameters = urlComponents.queryParameters,
               let offsetStr = queryParameters["offset"],
               let offset = Int(offsetStr),
               let limitStr = queryParameters["limit"] ,
               let limit = Int(limitStr),
               offset <= lastestID,
               offset+limit > lastestID {
                queryParameters["limit"] = "\(lastestID-offset)"
                urlComponents.queryItems = queryParameters.map { (key, value) in
                    URLQueryItem(name: key, value: value)
                }
                guard let newUrl = urlComponents.url else { return }
                nextUrl = newUrl
            }
            loadPokemonList(url: nextUrl)
        }
    }
}
