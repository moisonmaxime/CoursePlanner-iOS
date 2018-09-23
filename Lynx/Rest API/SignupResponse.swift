//
//  SignupResponse.swift
//  Lynx
//
//  Created by Maxime Moison on 8/27/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

struct SignupResponse: Codable {
    let accessKey: String?
    let refreshKey: String?
    let error: String?

    enum CodingKeys: String, CodingKey {
        case error
        case refreshKey = "refresh"
        case accessKey = "access"
    }
}
