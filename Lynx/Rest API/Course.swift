//
//  Course.swift
//  Lynx
//
//  Created by Maxime Moison on 8/27/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

struct Course: Codable, Equatable {

    let lecture: Section
    let discussion: Section?
    let lab: Section?

    var name: String { return lecture.shortName }
    var sections: [Section] {
        var sections: [Section] = []
        sections.append(lecture)
        if let discussion = discussion { sections.append(discussion) }
        if let lab = lab { sections.append(lab) }
        return sections
    }
    
    enum CodingKeys: String, CodingKey {
        case discussion = "DISC"
        case lab = "LAB"
        case lecture = "LECT"
    }
}
