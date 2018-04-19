//
//  Schedule.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/23/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class Schedule: NSObject {
    let earliest:Double
    let latest:Double
    let gaps:Int?
    let days:Int?
    
    var sections:[Section] = []
    
    var courses:[Course] {
        get {
            var arr:[Course] = []
            for s in sections {
                arr += s.courses
            }
            return arr
        }
    }
    
    var crns:[String] {
        get {
            var arr:[String] = []
            for s in sections {
                for c in s.courses {
                    arr.append(c.crn)
                }
            }
            return arr
        }
    }
    
    required init(info: Dictionary<String, Any>, courses: [String:[String:Any?]?]) {
        self.earliest = info["earliest"] as! Double
        self.latest = info["latest"] as! Double
        self.gaps = info["gaps"] as? Int
        self.days = info["number_of_days"] as? Int
        
        for c in courses {
            if (c.value == nil) {
                continue
            }
            sections.append(Section([c.key: c.value!]))
        }
    }
}
