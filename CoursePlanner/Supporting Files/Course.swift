//
//  Course.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 4/6/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class Section: NSObject {
    var name:String
    var lect:Course?
    var disc:Course?
    var lab:Course?
    
    var courses:[Course] {
        get {
            var arr:[Course] = []
            if (lect != nil) {
                arr.append(lect!)
            }
            if (disc != nil) {
                arr.append(disc!)
            }
            if (lab != nil) {
                arr.append(lab!)
            }
            return arr
        }
    }
    
    init(name: String, lect: Course?, disc: Course?, lab: Course?) {
        self.name = name
        self.lect = lect
        self.disc = disc
        self.lab = lab
    }
    
    init(_ dictionary: [String:[String:Any?]]) {
        let name = dictionary.keys.first?.uppercased()
        self.name = name != nil ? name! : "UNKNOWN"
        
        let lecture = dictionary.values.first?["LECT"] as? [String:Any?]
        let discussion = dictionary.values.first?["DISC"] as? [String:Any?]
        let laboratory = dictionary.values.first?["LAB"] as? [String:Any?]
        self.lect = lecture != nil ? Course(lecture!) : nil
        self.disc = discussion != nil ? Course(discussion!) : nil
        self.lab = laboratory != nil ? Course(laboratory!) : nil
    }
}

class Course: NSObject {
    
    var crn:String
    var subject:String?
    var courseID:String
    var name:String?
    var units:Int
    var type:String
    var days:String?
    var hours:String?
    var room:String?
    var instructor:String?
    var lecture:String?
    var attachedCourse:String?
    var term:String
    var capacity:Int
    var enrolled:Int
    var finalDays:String?
    var finalHours:String?
    var finalRoom:String?
    
    var availableSeats:Int {
        get {
            return capacity - enrolled
        }
    }
    var isFull:Bool {
        get {
            return enrolled >= capacity
        }
    }
    
    init(_ dict: [String:Any?]) {
        self.crn = dict["crn"] as! String
        self.courseID = dict["course_id"] as! String
        self.units = dict["units"] as! Int
        self.type = dict["type"] as! String
        self.term = dict["term"] as! String
        self.capacity = dict["capacity"] as! Int
        self.enrolled = dict["enrolled"] as! Int
        
        self.subject = dict["subject"] as? String
        self.name = dict["course_name"] as? String
        self.days = dict["days"] as? String
        self.hours = dict["hours"] as? String
        self.room = (dict["room"] as? String)?.readableRoom()
        self.instructor = dict["instructor"] as? String
        
        self.lecture = dict["lecture_crn"] as? String
        self.attachedCourse = dict["attached_crn"] as? String
        
        self.finalDays = dict["final_days"] as? String
        self.finalHours = dict["final_hours"] as? String
        self.finalRoom = (dict["final_room"] as? String)?.readableRoom()
    }
}
