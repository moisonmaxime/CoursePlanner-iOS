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
    
    required init(info: Dictionary<String, Any>, courses: Dictionary<String, Dictionary<String, Any?>>) {
        self.earliest = info["earliest"] as! Double
        self.latest = info["latest"] as! Double
        self.gaps = info["gaps"] as? Int
        self.days = info["days"] as? Int
        
        for c in courses {
            sections.append(Section([c.key: c.value]))
        }
    }
}
