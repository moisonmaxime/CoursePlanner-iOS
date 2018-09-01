//
//  CustomEvent.swift
//  Lynx
//
//  Created by Maxime Moison on 9/1/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

struct CustomEvent: Codable, Equatable {
    var name: String
    var start: Double
    var end: Double
    var days: String

    enum CodingKeys: String, CodingKey {
        case name = "event_name"
        case start = "start_time"
        case end = "end_time"
        case days
    }
}
