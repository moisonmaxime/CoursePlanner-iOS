//
//  StringExtension.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 4/1/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation

extension String {
    func extractTime() -> [String: Int] {
        let times = self.split(separator: "-")
        var startSubs = times[0].split(separator: ":")
        var endSubs = times[1].split(separator: ":")
        
        var startHour = ""
        let startMin = startSubs[1]
        var endHour = ""
        let endMin = String(String(endSubs[1]).prefix(2))
        
        if (endSubs[1].contains("pm")) {
            if (endSubs[0] != "12") {
                endHour = String(Int(endSubs[0])! + 12)
            } else {
                endHour = String(endSubs[0])
            }
            if (startSubs[0] != "12") {
                startHour = String(Int(startSubs[0])! + 12)
            } else {
                startHour = String(startSubs[0])
            }
        } else {
            startHour = String(startSubs[0])
            endHour = String(endSubs[0])
        }
        
        if (Int(startHour)! > Int(endHour)!) {
            startHour = String(Int(startHour)! - 12)
        }
        return ["start": Int(startHour + startMin)!, "end": Int(endHour + endMin)!]
    }
}
