//
//  DictionaryExtension.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/8/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == String {
    func toJSONString() -> String {
        var json = "{ "
        for key in self.keys {
            json.append("\"\(key)\": \"\(self[key] ?? "")\", ")
        }
        json.append("}")
        json = json.replacingOccurrences(of: ", }", with: " }")
        return json
    }
}
