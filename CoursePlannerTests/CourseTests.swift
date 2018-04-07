//
//  CourseTests.swift
//  CoursePlannerTests
//
//  Created by Maxime Moison on 4/6/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import XCTest

class CourseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    let testDictionary:[String:Any?] = [
        "crn": "15912",
        "subject": "Computer Science & Engineering",
        "course_id": "CSE-120-03L",
        "course_name": "Software Engineering",
        "units": 0,
        "type": "LAB",
        "days": "M",
        "hours": "10:30-1:20pm",
        "room": "CLSSRM 281",
        "dates": "16-JAN 04-MAY",
        "instructor": "Rakhmetulla",
        "lecture_crn": "15910",
        "attached_crn": nil,
        "term": "201810",
        "capacity": 20,
        "enrolled": 6,
        "available": 14,
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
        "simple_name": "CSE-120",
        "lecture": "15910",
        "discussion": nil
    ]
    
    let testFullDictionary:[String:Any?] = [
        "crn": "15912",
        "subject": "Computer Science & Engineering",
        "course_id": "CSE-120-03L",
        "course_name": "Software Engineering",
        "units": 0,
        "type": "LAB",
        "days": "M",
        "hours": "10:30-1:20pm",
        "room": "CLSSRM 281",
        "dates": "16-JAN 04-MAY",
        "instructor": "Rakhmetulla",
        "lecture_crn": "15910",
        "attached_crn": nil,
        "term": "201810",
        "capacity": 20,
        "enrolled": 21,
        "available": -1,
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
        "simple_name": "CSE-120",
        "lecture": "15910",
        "discussion": nil
    ]
    
    func testInitializationFromDictionary() {
        let testCourse = Course(testDictionary)
        XCTAssertNotNil(testCourse, "Failed initialization")
    }
    
    func testInitialization() {
        let testCourse = Course(testDictionary)
        XCTAssertTrue(testCourse.crn == testDictionary["crn"] as? String, "CRN was not parsed properly")
        XCTAssertTrue(testCourse.subject == testDictionary["subject"] as? String, "Subject was not parsed properly")
        XCTAssertTrue(testCourse.courseID == testDictionary["course_id"] as? String, "Course ID was not parsed properly")
        XCTAssertTrue(testCourse.name == testDictionary["course_name"] as? String, "Course Name was not parsed properly")
        XCTAssertTrue(testCourse.type == testDictionary["type"] as? String, "Type was not parsed properly")
    }
    
    func testInitializationDetails() {
        let testCourse = Course(testDictionary)
        XCTAssertTrue(testCourse.units == testDictionary["units"] as? Int, "Units was not parsed properly")
        XCTAssertTrue(testCourse.days == testDictionary["days"] as? String, "Days was not parsed properly")
        XCTAssertTrue(testCourse.hours == testDictionary["hours"] as? String, "Hours was not parsed properly")
        XCTAssertTrue(testCourse.room == (testDictionary["room"] as? String)?.readableRoom(), "Room was not parsed properly")
        XCTAssertTrue(testCourse.instructor == testDictionary["instructor"] as? String, "Instructor was not parsed properly")
        XCTAssertTrue(testCourse.capacity == testDictionary["capacity"] as? Int, "Instructor was not parsed properly")
        XCTAssertTrue(testCourse.enrolled == testDictionary["enrolled"] as? Int, "Instructor was not parsed properly")
    }
    
    func testInitializationRelations() {
        let testCourse = Course(testDictionary)
        XCTAssertTrue(testCourse.lecture == testDictionary["lecture_crn"] as? String, "Lecture was not parsed properly")
        XCTAssertTrue(testCourse.attachedCourse == testDictionary["attached_crn"] as? String, "Attached Course was not parsed properly")
    }
    
    func testInitializationFinal() {
        let testCourse = Course(testDictionary)
        XCTAssertTrue(testCourse.finalDays == testDictionary["final_days"] as? String, "Final Days was not parsed properly")
        XCTAssertTrue(testCourse.finalHours == testDictionary["final_hours"] as? String, "Final Hours was not parsed properly")
        XCTAssertTrue(testCourse.finalRoom == (testDictionary["final_room"] as? String)?.readableRoom(), "Final Room was not parsed properly")
    }
    
    func testAvailableSeats() {
        let testCourse = Course(testDictionary)
        let enrolled = testDictionary["enrolled"] as! Int
        let capacity = testDictionary["capacity"] as! Int
        XCTAssertTrue((capacity - enrolled) == testCourse.availableSeats, "Did not compute the number of available seats correctly")
    }
    
    func testIsFull() {
        let testCourse = Course(testDictionary)
        let enrolled = testDictionary["enrolled"] as! Int
        let capacity = testDictionary["capacity"] as! Int
        XCTAssertTrue((capacity <= enrolled) == testCourse.isFull, "Did not compute the isFull properly")
    }
}
