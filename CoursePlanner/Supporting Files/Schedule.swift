//
//  Schedule.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/23/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class Schedule: NSObject {
    let info:Dictionary<String, Any>
    let classes:Dictionary<String, Dictionary<String, Dictionary<String, Any?>>>
    
    required init(info: Dictionary<String, Any>, classes: Dictionary<String, Dictionary<String, Dictionary<String, Any?>>>) {
        self.info = info
        self.classes = classes
    }
    
    override var description: String {
        var desc = "Schedule"
        desc += "\n\tInfo"
        for i in info {
            desc += "\n\t\t\(i)"
        }
        desc += "\n\tClasses"
        for c in classes {
            desc += "\n\t\t\(c.key)"
            for a in c.value {
                desc += "\n\t\t\t\(a.key)"
                for b in a.value {
                    desc += "\n\t\t\t\(b)"
                }
            }
        }
        
        return desc + "\n"
    }
}
