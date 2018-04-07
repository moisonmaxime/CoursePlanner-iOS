//
//  RestAPITests.swift
//  CoursePlannerTests
//
//  Created by Maxime Moison on 4/6/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import XCTest

class RestAPITests: XCTestCase {
    
    let username = "ios-test"
    let userPassword = "weU-2Q8-Nac-xmY"
    
    var userDefaultsInitialState:[String:Any]?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let bundle = Bundle.main
        let defaults = UserDefaults.standard
        guard let name = bundle.bundleIdentifier else {
            fatalError("User Defaults Failure")
        }
        userDefaultsInitialState = defaults.persistentDomain(forName: name)
        defaults.setPersistentDomain([:], forName: name)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        if userDefaultsInitialState != nil {let bundle = Bundle.main
            let defaults = UserDefaults.standard
            guard let name = bundle.bundleIdentifier else {
                fatalError("User Defaults Failure")
            }
            defaults.setPersistentDomain(userDefaultsInitialState!, forName: name)
        }
        super.tearDown()
    }
    
    // ### - Test Login
    func testLogin() {
        let expect = expectation(description: "")
        RestAPI.login(user: username,
                      password: userPassword) { error in
                        XCTAssertNil(error)
                        expect.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // ### - Test CheckAPIKey
    func testCheckAPIKey() {
        testLogin()
        let expectCheck = expectation(description: "API Call - Check API Key")
        RestAPI.checkAPIKey { (error) in
            XCTAssertNil(error)
            expectCheck.fulfill()
        }
        wait(for: [expectCheck], timeout: 5)
    }
    
    // ### Test GetTerms
    func testGetTerms() {
        let expect = expectation(description: "API Call - Get Terms")
        RestAPI.getTerms { (terms, error) in
            XCTAssertNil(error)
            expect.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // ### - Test GetSections
    func testGetSections() {
        let expect = expectation(description: "API Call - Get Sections")
        let testID = "CSE-120"
        RestAPI.getSections(term: "201810", id: testID) { (courses, error) in
            XCTAssertNil(error)
            for course in courses! {
                XCTAssert((course["course_id"] as! String).contains(testID), "Search results are incorrect")
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // ### - Test SearchCourseID
    func testSearchCourseID() {
        let testID = "CSE1"
        let testTerm = "201810"
        let expect = expectation(description: "API Call - Search Course ID")
        RestAPI.searchCourseIDs(id: testID, term: testTerm) { (courses, error) in
            XCTAssertNil(error)
            expect.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // ### - Test GetSchedules
    func testGetSchedules() {
        let testCourses = ["CSE-120", "CSE-140", "CSE-150", "CSE-165", "ENGR-191"]
        let testTerm = "201810"
        let expect = expectation(description: "API Call - Get Schedules")
        RestAPI.getSchedules(term: testTerm, courses: testCourses) { (schedules, error) in
            XCTAssertNil(error)
            XCTAssertTrue(schedules!.count == 18)
            expect.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSaveSchedule() {
        
    }
    
    func testDeleteSchedule() {
        
    }
    
    func testDumpSchedules() {
        
    }
    
}
