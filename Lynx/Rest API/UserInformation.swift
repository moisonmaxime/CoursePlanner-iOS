//
//  UserInformation.swift
//  Lynx
//
//  Created by Maxime Moison on 8/27/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

struct UserInformation: Codable {
    let username: String
    let email: String?
    let name: String
    let uniqueID: String?
    let profileImageUrl: String?

    enum CodingKeys: String, CodingKey {
        case username
        case email
        case name
        case uniqueID = "unique_id"
        case profileImageUrl = "profile_image_url"
    }
}
