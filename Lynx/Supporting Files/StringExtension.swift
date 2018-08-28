//
//  StringExtension.swift
//  Lynx
//
//  Created by Maxime Moison on 4/1/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation

extension String {
    
    
    func extractTime() -> (Double, Double) {
        let times = self.split(separator: "-")
        var startSubs = times[0].split(separator: ":")
        var endSubs = times[1].split(separator: ":")
        
        var startHour = ""
        let startMin = Double(startSubs[1])! / 60
        var endHour = ""
        let endMin = Double(String(endSubs[1]).prefix(2))! / 60
        
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
        
        if ((Double(startHour)! + startMin) > (Double(endHour)! + endMin)) {
            startHour = String(Int(startHour)! - 12)
        }
        
        return (Double(startHour)! + startMin, Double(endHour)! + endMin)
    }
    
    func termID() -> String {
        let splitted  = self.split(separator: " ")
        return String(splitted[1]) + String(splitted[0] == "Fall" ? 30 : 10)
    }
    
    func readableTerm() -> String {
        let year = self.prefix(4)
        let term = self.suffix(from: .init(encodedOffset: 4))
        let TERMS = ["30": "Fall", "10": "Spring", "20": "Summer"]
        return "\(TERMS[String(term)] ?? String(term)) \(year)"
    }
    
    
    func readableRoom() -> String {
        var readableRoom = self.replacingOccurrences(of: "CLSSRM", with: "COB")
        readableRoom = readableRoom.replacingOccurrences(of: "SCIENG", with: "S&E")
        readableRoom = readableRoom.replacingOccurrences(of: "SE", with: "S&E")
        readableRoom = readableRoom.replacingOccurrences(of: "KOLLIG", with: "KL")
        return readableRoom
    }
    
}
