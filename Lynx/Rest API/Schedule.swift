//
//  Schedule.swift
//  Lynx
//
//  Created by Maxime Moison on 8/27/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//
import Foundation

struct Schedule: Codable, Equatable {

    private struct ScheduleInformation: Codable, Equatable {
        let numberOfDays: Int
        let earliest: Double
        let latest: Double
        let gaps: Double
        let hasConflictingFinals: Bool

        enum CodingKeys: String, CodingKey {
            case numberOfDays = "number_of_days"
            case earliest
            case latest
            case gaps
            case hasConflictingFinals
        }
    }

    private let schedule: [String: [Section]]
    private let info: ScheduleInformation
    var customEvents: [CustomEvent]

    var courses: [[Section]] { return schedule.map({ (_, sections) -> [Section] in return sections }) }
    var sections: [Section] {
        return courses.reduce([Section](), { (total, current) -> [Section] in
            total + current
        }).sorted()
    }
    var crns: [String] { return sections.map({ return $0.crn }) }
    var numberOfDays: Int { return info.numberOfDays }
    var earliest: Double { return info.earliest }
    var latest: Double { return info.latest }
    var gaps: Double { return info.gaps }
    var hasConflictingFinals: Bool { return info.hasConflictingFinals }

    enum CodingKeys: String, CodingKey {
        case schedule
        case info
        case customEvents = "custom_events"
    }
}


extension Array where Element == Section {
    func sorted() -> [Section] {
        return self.sorted(by: { (first, second) -> Bool in
            let first = first.courseID.split(separator: "-")
            let second = second.courseID.split(separator: "-")
            
            let firstName = first[0]
            let firstNumber = Int(first[1].trimmingCharacters(in: CharacterSet.decimalDigits.inverted)) ?? 0
            let firstSection = Int(first[2].trimmingCharacters(in: CharacterSet.decimalDigits.inverted)) ?? 0
            
            let secondName = second[0]
            let secondNumber = Int(second[1].trimmingCharacters(in: CharacterSet.decimalDigits.inverted)) ?? 0
            let secondSection = Int(second[2].trimmingCharacters(in: CharacterSet.decimalDigits.inverted)) ?? 0
            
            if firstName == secondName {
                if firstNumber == secondNumber {
                    if firstSection == secondSection {
                        return first[2] < second[2]
                    }
                    return firstSection < secondSection
                }
                return firstNumber < secondNumber
            }
            return firstName < secondName
        })
    }
}
