//
//  HoursTests.swift
//  CoursePlannerTests
//
//  Created by Maxime Moison on 4/7/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import XCTest

class HoursTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    let expectedResults:[String:(Double, Double)] = [
        "12:00-1:00pm": (12, 13),
        "10:00-1:00pm": (10, 13),
        "10:00-11:00am": (10, 11),
        "3:00-5:00pm": (15, 17),
        "8:00-7:00pm": (8, 19),
        "8:15-10:15am": (8.25, 10.25),
        "8:30-10:30am": (8.5, 10.5),
        "8:45-10:45am": (8.75, 10.75)
    ]
    
    func testNoonPM() {
        let test = "12:00-1:00pm"
        let result = test.extractTime()
        XCTAssertEqual(result.0, expectedResults[test]?.0)
        XCTAssertEqual(result.1, expectedResults[test]?.1)
    }
    
    func testAMPM() {
        let test = "10:00-1:00pm"
        let result = test.extractTime()
        XCTAssertEqual(result.0, expectedResults[test]?.0)
        XCTAssertEqual(result.1, expectedResults[test]?.1)
    }
    
    func testAM() {
        let test = "10:00-11:00am"
        let result = test.extractTime()
        XCTAssertEqual(result.0, expectedResults[test]?.0)
        XCTAssertEqual(result.1, expectedResults[test]?.1)
    }
    
    func testPM() {
        let test = "10:00-11:00am"
        let result = test.extractTime()
        XCTAssertEqual(result.0, expectedResults[test]?.0)
        XCTAssertEqual(result.1, expectedResults[test]?.1)
    }
    
    func testLongDay() {
        let test = "8:00-7:00pm"
        let result = test.extractTime()
        XCTAssertEqual(result.0, expectedResults[test]?.0)
        XCTAssertEqual(result.1, expectedResults[test]?.1)
    }
    
    func testQuarterPast() {
        let test = "8:15-10:15am"
        let result = test.extractTime()
        XCTAssertEqual(result.0, expectedResults[test]?.0)
        XCTAssertEqual(result.1, expectedResults[test]?.1)
    }
    
    func testHalfPast() {
        let test = "8:30-10:30am"
        let result = test.extractTime()
        XCTAssertEqual(result.0, expectedResults[test]?.0)
        XCTAssertEqual(result.1, expectedResults[test]?.1)
    }
    
    func testQuarterTo() {
        let test = "8:45-10:45am"
        let result = test.extractTime()
        XCTAssertEqual(result.0, expectedResults[test]?.0)
        XCTAssertEqual(result.1, expectedResults[test]?.1)
    }
}
