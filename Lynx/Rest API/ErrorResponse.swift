//
//  ErrorResponse.swift
//  Lynx
//
//  Created by Maxime Moison on 10/20/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable {
    let title: String
    let description: String
    let code: Int
    
    enum CodingKeys: String, CodingKey {
        case title = "error_title"
        case description = "error_description"
        case code = "error_code"
    }
}
