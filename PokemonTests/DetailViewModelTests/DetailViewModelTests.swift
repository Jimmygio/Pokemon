//
//  DetailViewModelTests.swift
//  PokemonTests
//
//  Created by Chang Chin-Ming on 2024/3/10.
//

import XCTest
@testable import Pokemon

final class DetailViewModelTests: XCTestCase {
    
    var apiHelperMock: APIHelperMock_DetailViewModelTest!
    var ownedHelperMock: OwnedHelperMock!
    var detailDataHelperMock: DetailDataHelperMock_DetailViewModelTests!
    var detailViewModel: DetailViewModelProtocol!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        apiHelperMock = APIHelperMock_DetailViewModelTest()
        ownedHelperMock = OwnedHelperMock()
        detailDataHelperMock = DetailDataHelperMock_DetailViewModelTests()
        detailViewModel = DetailViewModel(apiHelper: apiHelperMock,
                                          ownedHelper: ownedHelperMock,
                                          detailDataHelper: detailDataHelperMock)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    private let detailData1 = DetailData(forms: [NameAndUrlData(name: "bulbasaur",
                                                                url: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!)],
                                         id: 1,
                                         types: [DetailData.TypeData(type: NameAndUrlData(name: "grass",
                                                                                          url: URL(string: "https://pokeapi.co/api/v2/type/12/")!))],
                                         sprites: DetailData.SpritesData(front_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!,
                                                                         front_female: nil),
                                         stats: [DetailData.StatData(base_stat: 45, stat: NameAndUrlData(name: "hp",
                                                                                                         url: URL(string: "https://pokeapi.co/api/v2/stat/1/")!))],
                                         species: NameAndUrlData(name: "bulbasaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon-species/1/")!))
    private let detailData2 = DetailData(forms: [NameAndUrlData(name: "ivysaur",
                                                                url: URL(string: "https://pokeapi.co/api/v2/pokemon/2/")!)],
                                         id: 2,
                                         types: [DetailData.TypeData(type: NameAndUrlData(name: "grass",
                                                                                          url: URL(string: "https://pokeapi.co/api/v2/type/12/")!))],
                                         sprites: DetailData.SpritesData(front_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png")!,
                                                                         front_female: nil),
                                         stats: [DetailData.StatData(base_stat: 60, stat: NameAndUrlData(name: "hp",
                                                                                                         url: URL(string: "https://pokeapi.co/api/v2/stat/2/")!))],
                                         species: NameAndUrlData(name: "ivysaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon-species/2/")!))
    private let detailData3 = DetailData(forms: [NameAndUrlData(name: "venusaur",
                                                                url: URL(string: "https://pokeapi.co/api/v2/pokemon/3/")!)],
                                         id: 3,
                                         types: [DetailData.TypeData(type: NameAndUrlData(name: "grass",
                                                                                          url: URL(string: "https://pokeapi.co/api/v2/type/12/")!))],
                                         sprites: DetailData.SpritesData(front_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/3.png")!,
                                                                         front_female: nil),
                                         stats: [DetailData.StatData(base_stat: 80, stat: NameAndUrlData(name: "hp",
                                                                                                         url: URL(string: "https://pokeapi.co/api/v2/stat/3/")!))],
                                         species: NameAndUrlData(name: "venusaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon-species/3/")!))
    
    func testLoadDescriptionAndEvolution() async throws {
        detailDataHelperMock.detailData1 = detailData1
        detailDataHelperMock.detailData2 = detailData2
        detailDataHelperMock.detailData3 = detailData3

        // 目前Detail頁顯示的是bulbasaur
        detailViewModel.detailData = detailData1
        
        let expectation = XCTestExpectation(description: "testLoadDescriptionAndEvolution timeout")
        let expectation2 = XCTestExpectation(description: "testLoadDescriptionAndEvolution timeout 2")
        detailViewModel.loadDescriptionAndEvolution { str in
            // 檢查取得的Description
            XCTAssertEqual(str, "A strange seed was planted on its back at birth.The plant sprouts and grows with this POKéMON.",
                           "testLoadDescriptionAndEvolution fail, description = \(str)")
            
            expectation.fulfill()
        } evolutionCompletion: { [weak self] detailDatas in
            guard let tSelf = self else {
                XCTAssert(false, "testLoadDescriptionAndEvolution fail, self = nil")
                return
            }
            
            let expectedDatas = [tSelf.detailData1, tSelf.detailData2, tSelf.detailData3]
            // 檢查取得的Evolution Chain
            XCTAssertEqual(detailDatas, expectedDatas, "testLoadDescriptionAndEvolution fail, detailDatas = \(detailDatas)")
            
            expectation2.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 0.5)
        await fulfillment(of: [expectation2], timeout: 0.5)
    }
    
    func testIsOwned() async throws {
        detailViewModel.detailData = detailData1
        ownedHelperMock.expectedIsOwned = true
        var result = await detailViewModel.isOwned()
        XCTAssertTrue(result, "testIsOwned fail 1, result = \(result)")

        detailViewModel.detailData = detailData1
        ownedHelperMock.expectedIsOwned = false
        result = await detailViewModel.isOwned()
        XCTAssertFalse(result, "testIsOwned fail 2, result = \(result)")

        detailViewModel.detailData = nil
        ownedHelperMock.expectedIsOwned = true
        result = await detailViewModel.isOwned()
        XCTAssertFalse(result, "testIsOwned fail 3, result = \(result)")
    }
    
    func testChangeOwnedStatus() async throws {
        detailViewModel.detailData = detailData1
        ownedHelperMock.expectedIsOwned = true
        await detailViewModel.changeOwnedStatus()
        var result = ownedHelperMock.expectedNameToChnageOwnedStatus
        XCTAssertEqual(result, "bulbasaur", "testChangeOwnedStatus fail 1, result = \(String(describing: result))")

        detailViewModel.detailData = detailData1
        ownedHelperMock.expectedIsOwned = false
        await detailViewModel.changeOwnedStatus()
        result = ownedHelperMock.expectedNameToChnageOwnedStatus
        XCTAssertEqual(result, "bulbasaur", "testChangeOwnedStatus fail 2, result = \(String(describing: result))")

        detailViewModel.detailData = nil
        ownedHelperMock.expectedIsOwned = true
        await detailViewModel.changeOwnedStatus()
        result = ownedHelperMock.expectedNameToChnageOwnedStatus
        XCTAssertEqual(result, "bulbasaur", "testChangeOwnedStatus fail 3, result = \(String(describing: result))")
    }
}
