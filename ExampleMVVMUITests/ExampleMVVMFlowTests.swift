//
//  ExampleMVVMFlowTests.swift
//  ExampleMVVMUITests
//
//  Created by 최하식 on 5/15/24.
//

import XCTest

final class ExampleMVVMFlowTests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        app = nil
    }
    
    func testSearchBar(){
        
        let app = XCUIApplication()
        let searchMoviesStaticText = app.staticTexts["Search Movies"]
        searchMoviesStaticText.tap()
        app.buttons["Cancel"].tap()
    }
}
