//
//  Section.swift
//  Lynx
//
//  Created by Maxime Moison on 8/27/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

struct Section: Codable, Equatable {
    
    let crn: String
    let subject: String
    let courseID: String
    let name: String
    let shortName: String
    let units: Int
    let type: String
    let days: String
    let hours: String
    let room: String
    let instructor: String
    let lecture: String?
    let attachedCourse: String?
    let capacity: Int
    let enrolled: Int
    let finalDays: String?
    let finalHours: String?
    let dependents: [String]
    
    var isFull: Bool { return enrolled >= capacity }
    var available: Int { return capacity - enrolled}
    var sectionID:String {
        return String((courseID.split(separator: "-").last?.prefix(2))!)
    }
    
    enum CodingKeys: String, CodingKey {
        case crn = "crn"
        case subject = "subject"
        case courseID = "course_id"
        case name = "course_name"
        case shortName = "simple_name"
        case units = "units"
        case type = "type"
        case days = "days"
        case hours = "hours"
        case room = "room"
        case instructor = "instructor"
        case lecture = "lecture_crn"
        case attachedCourse = "attached_crn"
        case capacity = "capacity"
        case enrolled = "enrolled"
        case finalDays = "final_days"
        case finalHours = "final_hours"
        case dependents = "linked_courses"
    }
}
