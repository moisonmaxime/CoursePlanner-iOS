//
//  Schedule.swift
//  Lynx
//
//  Created by Maxime Moison on 3/23/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit
//
//class Schedule: NSObject {
//    let earliest:Double
//    let latest:Double
//    let gaps:Int?
//    let days:Int?
//    
//    var sections:[Section] = []
//    
//    var courses:[Course] {
//        get {
//            var arr:[Course] = []
//            for section in sections {
//                arr += section.courses
//            }
//            return arr
//        }
//    }
//    
//    var crns:[String] {
//        get {
//            var arr:[String] = []
//            for section in sections {
//                for course in section.courses {
//                    arr.append(course.crn)
//                }
//            }
//            return arr
//        }
//    }
//    
//    required init(info: [String: Any], courses: [String:[String:Any?]]) {
//        self.earliest = info["earliest"] as? Double ?? 0
//        self.latest = info["latest"] as? Double ?? 0
//        self.gaps = info["gaps"] as? Int
//        self.days = info["number_of_days"] as? Int
//        
//        for course in courses {
//            sections.append(Section([course.key: course.value]))
//        }
//    }
//}
