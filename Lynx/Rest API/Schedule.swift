//
//  Schedule.swift
//  Lynx
//
//  Created by Maxime Moison on 8/27/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

struct Schedule: Codable, Equatable {

    private struct ScheduleInformation: Codable, Equatable {
        let numberOfDays: Int
        let earliest: Double
        let latest: Double
        let gaps: Double

        enum CodingKeys: String, CodingKey {
            case numberOfDays = "number_of_days"
            case earliest
            case latest
            case gaps
        }
    }

    private let schedule: [String: [Section]]
    private let info: ScheduleInformation
    var customEvents: [CustomEvent]

    var courses: [[Section]] { return schedule.map({ (_, sections) -> [Section] in return sections }) }
    var sections: [Section] {
        return courses.reduce([Section](), { (total, current) -> [Section] in
            total + current
        })
    }
    var crns: [String] { return sections.map({ return $0.name }) }
    var numberOfDays: Int { return info.numberOfDays }
    var earliest: Double { return info.earliest }
    var latest: Double { return info.latest }
    var gaps: Double { return info.gaps }

    enum CodingKeys: String, CodingKey {
        case schedule
        case info
        case customEvents = "custom_events"
    }
}
