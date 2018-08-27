//
//  LynxUITests.swift
//  LynxUITests
//
//  Created by Maxime Moison on 4/7/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import XCTest

class LynxUITests: XCTestCase {
    
    let username = "ios-test"
    let userPassword = "weU-2Q8-Nac-xmY"
    
    let term = "Spring 2018"
    
    let testCourses = ["CSE-120": ["03L"],
                       "CSE-140": ["02L", "03L"],
                       "CSE-150": ["02L", "03L"],
                       "CSE-165": ["02L", "03L", "05L"],
                       "ENGR-191": []]
    
    let expectedSchedule = ["CSE-120-01", "CSE-120-02L", "CSE-140-01", "CSE-140-04L",
                            "CSE-150-01", "CSE-150-04L", "CSE-165-01", "CSE-165-04L",
                            "ENGR-191-01"]
    
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
    
    func testSchedule() {
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
        
        XCTAssertTrue(app.tables.staticTexts[term].waitForExistence(timeout: 3))
        app.tables.staticTexts[term].tap()
        app.buttons["Build New Schedule"].tap()
        
        let searchField = app.searchFields["Search For Classes"]
        searchField.tap()
        
        for courseID in testCourses.keys {
            searchField.typeText(courseID)
            XCTAssertTrue(app.tables.staticTexts[courseID].waitForExistence(timeout: 3), "Search failed to find \(courseID)")
            app.tables.staticTexts[courseID].tap()
            searchField.buttons["Clear text"].tap()
        }
        searchField.typeText("\n")
        
        for (key, filters) in testCourses {
            app.tables.staticTexts[key].tap()
            for filter in filters {
                app.tables.staticTexts["\(key)-\(filter)"].tap()
            }
            app.buttons["◀︎"].tap()
        }
        
        app.buttons["Build"].tap()
        XCTAssertTrue(app.staticTexts["1/1"].waitForExistence(timeout: 3))
        
        for course in expectedSchedule {
            XCTAssertTrue(app.staticTexts[course].exists, "\(course) is missing")
        }
    }
    
    
    func testEmptySchedule() {
        let app = XCUIApplication()
        
        let userField = app.textFields["Username"]
        if (userField.exists) {
            userField.tap()
            userField.typeText(username)
            let passField = app.secureTextFields["Password"]
            passField.tap()
            passField.typeText(userPassword)
            app.buttons["Login"].tap()
            XCTAssertTrue(app.buttons["Build New Schedule"].waitForExistence(timeout: 3))
        }
        
        XCTAssertTrue(app.tables.staticTexts[term].waitForExistence(timeout: 3))
        app.tables.staticTexts[term].tap()
        app.buttons["Build New Schedule"].tap()
        
        app.buttons["Build"].tap()
        XCTAssertTrue(app.staticTexts["No Schedule"].waitForExistence(timeout: 3), "Does not display a message when no schedule was found")
        
    }
}
