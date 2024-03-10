//
//  OwnedButtonUITests.swift
//  PokemonUITests
//
//  Created by Chang Chin-Ming on 2024/3/10.
//

import XCTest

final class OwnedButtonUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOwnedButton() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        // 找到指定的cell
        let cell = app.collectionViews.cells[AccessibilityId.loadListCollectionViewCell(name: "bulbasaur")].firstMatch
        XCTAssert(cell.waitForExistence(timeout: 5), "ownedButtonTest fail, not find cell")
        cell.tap()
        
        // 進入DetailViewController
        let ownedButton = app.buttons[AccessibilityId.detailViewController_OwnedButton.rawValue].firstMatch
        XCTAssert(ownedButton.waitForExistence(timeout: 5), "ownedButtonTest fail, not find owned button")
        switch ownedButton.label {
            case OwnedButtonTitle.Unowned.rawValue:
            ownedButton.tap()
            XCTAssertEqual(ownedButton.staticTexts.firstMatch.label, OwnedButtonTitle.owned.rawValue, "ownedButtonTest fail, ownedButton.staticTexts.firstMatch.label = \(ownedButton.staticTexts.firstMatch.label)")
            
            case OwnedButtonTitle.owned.rawValue:
            ownedButton.tap()
            XCTAssertEqual(ownedButton.staticTexts.firstMatch.label, OwnedButtonTitle.Unowned.rawValue, "ownedButtonTest fail, ownedButton.staticTexts.firstMatch.label = \(ownedButton.staticTexts.firstMatch.label)")
            
        default:
            XCTAssert(false, "ownedButtonTest no ownedButton.label")
        }
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
