//
//  SectionTests.swift
//  CoursePlannerTests
//
//  Created by Maxime Moison on 4/6/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import XCTest

class SectionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    let testDictionary:[String:[String:[String:Any?]]] = [
        "Phys-8": [
            "DISC": [
                "crn": "13794",
                "subject": "Physics",
                "course_id": "PHYS-008-21D",
                "course_name": "Introductory Physics I",
                "units": 0,
                "type": "DISC",
                "days": "R",
                "hours": "9:30-11:20am",
                "room": "CLSSRM 266",
                "dates": "16-JAN 04-MAY",
                "instructor": "Tan",
                "lecture_crn": "13793",
                "attached_crn": "13795",
                "term": "201810",
                "capacity": 24,
                "enrolled": 23,
                "available": 1,
                "final_type": nil,
                "final_days": nil,
                "final_hours": nil,
                "final_room": nil,
                "final_dates": nil,
                "final_type_2": nil,
                "final_days_2": nil,
                "final_hours_2": nil,
                "final_room_2": nil,
                "final_dates_2": nil,
                "simple_name": "PHYS-8",
                "lecture": "13793",
                "discussion": nil
            ],
            "LAB": [
                "crn": "13795",
                "subject": "Physics",
                "course_id": "PHYS-008-21L",
                "course_name": "Introductory Physics I",
                "units": 0,
                "type": "LAB",
                "days": "T",
                "hours": "9:30-11:20am",
                "room": "SCIENG 107",
                "dates": "16-JAN 04-MAY",
                "instructor": "Tan",
                "lecture_crn": "13793",
                "attached_crn": "13794",
                "term": "201810",
                "capacity": 24,
                "enrolled": 23,
                "available": 1,
                "final_type": nil,
                "final_days": nil,
                "final_hours": nil,
                "final_room": nil,
                "final_dates": nil,
                "final_type_2": nil,
                "final_days_2": nil,
                "final_hours_2": nil,
                "final_room_2": nil,
                "final_dates_2": nil,
                "simple_name": "PHYS-8",
                "lecture": "13793",
                "discussion": nil
            ],
            "LECT": [
                "crn": "13793",
                "subject": "Physics",
                "course_id": "PHYS-008-20",
                "course_name": "Introductory Physics I",
                "units": 4,
                "type": "LECT",
                "days": "TR",
                "hours": "6:00-7:15pm",
                "room": "COB2 130",
                "dates": "16-JAN 04-MAY",
                "instructor": "Hirst",
                "lecture_crn": nil,
                "attached_crn": nil,
                "term": "201810",
                "capacity": 144,
                "enrolled": 141,
                "available": 3,
                "final_type": "EXAM",
                "final_days": "M",
                "final_hours": "11:30-2:30pm",
                "final_room": "COB2 130",
                "final_dates": "07-MAY 07-MAY",
                "final_type_2": nil,
                "final_days_2": nil,
                "final_hours_2": nil,
                "final_room_2": nil,
                "final_dates_2": nil,
                "simple_name": "PHYS-8",
                "lecture": nil,
                "discussion": nil
            ]
        ]
    ]
    
    let testEmpty:[String:[String:[String:Any?]]] = ["Phys-8": [:]]
    
    func testInitialization() {
        let testSection = Section(testDictionary)
        XCTAssertTrue(testDictionary["Phys-8"]!["LECT"]!["crn"] as? String == testSection.lect?.crn)
        XCTAssertTrue(testDictionary["Phys-8"]!["DISC"]!["crn"] as? String  == testSection.disc?.crn)
        XCTAssertTrue(testDictionary["Phys-8"]!["LAB"]!["crn"] as? String == testSection.lab?.crn)
    }
    
}
