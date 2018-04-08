//
//  CoursePlannerUITests.swift
//  CoursePlannerUITests
//
//  Created by Maxime Moison on 4/7/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import XCTest

class CoursePlannerUITests: XCTestCase {
    
    let username = "ios-test"
    let userPassword = "weU-2Q8-Nac-xmY"
    
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
    
    func testSpringSchedule() {
        let app = XCUIApplication()
        
        let userField = app.textFields["Username"]
        if (userField.exists) {
            userField.tap()
            userField.typeText(username)
            let passField = app.secureTextFields["Password"]
            passField.tap()
            passField.typeText(userPassword)
            app.buttons["Login"].tap()
            XCTAssertTrue(app.buttons["Build New Schedule"].waitForExistence(timeout: 10))
        }
        
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Spring 2018"]/*[[".cells.staticTexts[\"Spring 2018\"]",".staticTexts[\"Spring 2018\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Build New Schedule"].tap()
        
        let searchField = app.searchFields["Search For Classes"]
        searchField.tap()
        
        searchField.typeText("cse1")
        app.tables.staticTexts["CSE-120"].tap()
        app.tables.staticTexts["CSE-140"].tap()
        app.tables.staticTexts["CSE-150"].tap()
        app.tables.staticTexts["CSE-165"].tap()
        searchField.buttons["Clear text"].tap()
        searchField.typeText("Engr191")
        app.tables.staticTexts["ENGR-191"].tap()
        searchField.typeText("\n")
        
        app.tables.staticTexts["CSE-120"].tap()
        app.tables.staticTexts["CSE-120-03L"].tap()
        app.buttons["◀︎"].tap()
        
        app.tables.staticTexts["CSE-140"].tap()
        app.tables.staticTexts["CSE-140-02L"].tap()
        app.tables.staticTexts["CSE-140-03L"].tap()
        app.buttons["◀︎"].tap()
        
        app.tables.staticTexts["CSE-150"].tap()
        app.tables.staticTexts["CSE-150-02L"].tap()
        app.tables.staticTexts["CSE-150-03L"].tap()
        app.buttons["◀︎"].tap()
        
        app.tables.staticTexts["CSE-165"].tap()
        app.tables.staticTexts["CSE-165-02L"].tap()
        app.tables.staticTexts["CSE-165-03L"].tap()
        app.tables.staticTexts["CSE-165-05L"].tap()
        app.buttons["◀︎"].tap()
        
        app.buttons["Build"].tap()
        XCTAssertTrue(app.staticTexts["1/1"].waitForExistence(timeout: 3))
        
        XCTAssertTrue(app.staticTexts["CSE-120-01"].exists)
        XCTAssertTrue(app.staticTexts["CSE-120-02L"].exists)
        XCTAssertTrue(app.staticTexts["CSE-140-01"].exists)
        XCTAssertTrue(app.staticTexts["CSE-140-04L"].exists)
        XCTAssertTrue(app.staticTexts["CSE-150-01"].exists)
        XCTAssertTrue(app.staticTexts["CSE-150-04L"].exists)
        XCTAssertTrue(app.staticTexts["CSE-165-01"].exists)
        XCTAssertTrue(app.staticTexts["CSE-165-04L"].exists)
        XCTAssertTrue(app.staticTexts["ENGR-191-01"].exists)
    }
    
    
}
