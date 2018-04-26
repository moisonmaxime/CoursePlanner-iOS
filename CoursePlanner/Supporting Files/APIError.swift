//
//  APIError.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/16/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation

enum APIError: Error {
    case NetworkError
    case ServerError
    case InvalidAPIKey
    case InvalidCredentials
    case InternalError
    case ServiceUnavailable
    case NotFound
    case OutOfSpace
    case NoMatchingUser
}
