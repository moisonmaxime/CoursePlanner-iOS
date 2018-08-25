//
//  StandardScheduleUITests.swift
//  CoursePlannerUITests
//
//  Created by Maxime Moison on 8/25/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import XCTest

class StandardScheduleUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMain() {
        let app = XCUIApplication()
        
        
        app.textFields["Search for classes"].tap()
        app.textFields["Search for classes"].typeText("CSE111")
        XCTAssertEqual(app.alerts.count, 0, "Alert Message")
        app.tables.cells.staticTexts["CSE-111"].tap()
        app.buttons["Cross"].tap()
        app.textFields["Search for classes"].typeText("CSE175")
        XCTAssertEqual(app.alerts.count, 0, "Alert Message")
        app.tables.cells.staticTexts["CSE-175"].tap()
        app.buttons["Cross"].tap()
        app.textFields["Search for classes"].typeText("WRI118")
        XCTAssertEqual(app.alerts.count, 0, "Alert Message")
        app.tables.cells.staticTexts["WRI-118"].tap()
        app.buttons["Cross"].tap()
        app.textFields["Search for classes"].typeText("GASP10")
        XCTAssertEqual(app.alerts.count, 0, "Alert Message")
        app.tables.cells.staticTexts["GASP-10"].tap()
        app.textFields["Search for classes"].typeText("\n")
        
        app.tables.cells.staticTexts["CSE-111"].tap()
        XCTAssertEqual(app.alerts.count, 0, "Alert Message")
        app.tables.cells.staticTexts["CSE-111-02L"].tap()
        app.tables.cells.staticTexts["CSE-111-02L"].tap()
        app.buttons["◀︎"].tap()
        
        app.buttons["Build"].tap()
        XCTAssertEqual(app.alerts.count, 0, "Alert Message")
        app.buttons["Details"].tap()
        XCTAssertEqual(app.alerts.count, 0, "Alert Message")
    }
    
}
