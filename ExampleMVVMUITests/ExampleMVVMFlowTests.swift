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
        
        app.searchFields["Search"].tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Cancel"]/*[[".buttons[\"Cancel\"].staticTexts[\"Cancel\"]",".staticTexts[\"Cancel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
}
