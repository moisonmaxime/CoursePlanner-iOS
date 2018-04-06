//
//  ReadableTermTest.swift
//  CoursePlannerTests
//
//  Created by Maxime Moison on 4/6/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import XCTest

class ReadableTermTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSpring() {
        XCTAssertTrue("201810".readableTerm() == "Spring 2018")
    }
    
    func testFall() {
        XCTAssertTrue("201830".readableTerm() == "Fall 2018")
    }
}
