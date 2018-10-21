//
//  SignupResponse.swift
//  Lynx
//
//  Created by Maxime Moison on 8/27/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

struct SignupResponse: Codable {
    let userInfo: UserInformation
    private let keys: LoginResponse
    let error: String?
    
    var refreshKey: String? {
        return keys.refreshKey
    }
    var accessKey: String? {
        return keys.accessKey
    }

    enum CodingKeys: String, CodingKey {
        case error
        case userInfo = "user"
        case keys = "api_keys"
    }
}
