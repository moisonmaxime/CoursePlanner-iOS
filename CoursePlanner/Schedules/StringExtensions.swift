//
//  StringExtensions.swift
//  WeekCalendar
//
//  Created by Maxime Moison on 2/13/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation

extension String {
    func timeToDecimal() -> Double{
        let splitted = self.split(separator: ":")
        return Double(splitted[0])! + Double(splitted[1])!/60
    }
    
    func time24toAmPm() -> String {
        let splitted = self.split(separator: ":")
        if (Int(splitted[0])! > 12) {
            return "\(Int(splitted[0])! - 12):\(splitted[1])"
        } else {
            return self
        }
    }
}
