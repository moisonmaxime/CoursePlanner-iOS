//
//  ReadableRoomTests.swift
//  LynxTests
//
//  Created by Maxime Moison on 4/6/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import XCTest

class ReadableRoomTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCOB() {
        XCTAssertTrue("CLSSRM 100".readableRoom() == "COB 100")
    }
    
    func testCOB2() {
        XCTAssertTrue("COB2 100".readableRoom() == "COB2 100")
    }
    
    func testSE() {
        XCTAssertTrue("SCIENG 100".readableRoom() == "S&E 100")
    }
    
    func testSE2() {
        XCTAssertTrue("SE2 100".readableRoom() == "S&E2 100")
    }
    
    func testSSB() {
        XCTAssertTrue("SSB 100".readableRoom() == "SSB 100")
    }
}
