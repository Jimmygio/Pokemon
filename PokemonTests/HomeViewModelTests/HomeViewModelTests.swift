//
//  HomeViewModelTests.swift
//  HomeViewModelTests
//
//  Created by Chang Chin-Ming on 2024/3/9.
//

import XCTest
@testable import Pokemon

final class HomeViewModelTests: XCTestCase {
    
    var apiHelperMock: APIHelperMock!
    var ownedHelperMock: OwnedHelperMock!
    var homeViewModel: HomeViewModelProtocol!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        apiHelperMock = APIHelperMock()
        ownedHelperMock = OwnedHelperMock()
        homeViewModel = HomeViewModel(apiHelper: apiHelperMock, 
                                      ownedHelper: ownedHelperMock)
        
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLoadPokemonList() async throws {
        let expectation = XCTestExpectation(description: "testLoadPokemonList timeout")
        let expectedData = try loadPokemonList()
        homeViewModel.updateUIClosure = { [weak self] in
            guard let tSelf = self else {
                XCTAssert(false, "testLoadPokemonList fail, self = nil")
                return
            }
            
            // 比對回傳結果正不正確
            XCTAssertEqual(tSelf.homeViewModel.showedDatas,
                           expectedData,
                           "testLoadPokemonList fail, homeViewModel.showedDatas = \(tSelf.homeViewModel.showedDatas)")
            
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 0.5)
    }
    
    private func loadPokemonList() throws -> [NameAndUrlData] {
        let jsonStr =
        """
        {
           "count":1302,
           "next":"https://pokeapi.co/api/v2/pokemon?offset=3&limit=3",
           "previous":null,
           "results":[
              {
                 "name":"bulbasaur",
                 "url":"https://pokeapi.co/api/v2/pokemon/1/"
              },
              {
                 "name":"ivysaur",
                 "url":"https://pokeapi.co/api/v2/pokemon/2/"
              },
              {
                 "name":"venusaur",
                 "url":"https://pokeapi.co/api/v2/pokemon/3/"
              }
           ]
        }
        """
        let data = Data(jsonStr.utf8)
        let expectedData = try JSONDecoder().decode(ListData.self, from: data).results
        
        // Mock API的回傳結果
        apiHelperMock.expectedData = data
        homeViewModel.loadPokemonList()
        
        return expectedData
    }
    
    func testChangeOwnedMode() async throws {
        // 在測試testLoadPokemonList裡面已經證實loadPokemonList是正確的
        // 呼叫loadPokemonList是為了設定homeViewModel.showedDatas的參數值
        _ = try loadPokemonList()
        homeViewModel.updateUIClosure = { [weak self] in
            guard let tSelf = self else {
                XCTAssert(false, "testChangeOwnedMode fail, self = nil")
                return
            }
            
            // 假設只有bulbasaur是owned
            tSelf.ownedHelperMock.expectedOwnedArray = ["bulbasaur"]
            
            tSelf.homeViewModel.updateUIClosure = nil
            let ownedMode = tSelf.homeViewModel.changeOwnedMode()
            // 預設是disbale, 所以更改後會是enable
            XCTAssertEqual(ownedMode, .enable, "testChangeOwnedMode fail, ownedMode = \(ownedMode)")
            
            let expectedData = [NameAndUrlData(name: "bulbasaur",
                                               url: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!)]
            
            // 檢查資料變更為只有一筆bulbasaur資料的Array
            XCTAssertEqual(tSelf.homeViewModel.showedDatas, expectedData, "testChangeOwnedMode fail, tSelf.homeViewModel.showedDatas = \(tSelf.homeViewModel.showedDatas)")
        }
    }
}
