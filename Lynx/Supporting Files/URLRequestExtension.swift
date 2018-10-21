//
//  URLRequestExtension.swift
//  Lynx
//
//  Created by Maxime Moison on 3/9/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation

// MARK: - API Error

enum APIError {
    case networkError
    
    case serverError
    case notAcceptable
    case unknownError
    
    case invalidAPIKey
    case invalidCredentials
    
    case internalError
    case serviceUnavailable
    
    case notFound
    case outOfSpace
    case noMatchingUser
    case userAlreadyExists
}

extension APIError {
    var message: String {
        switch self {
        case .networkError: return "Check your internet connection"             // internal
            
        case .serverError: return "Oh my! Something went wrong"                 // http - 500
        case .notAcceptable: return "Server Error"                              // http - 406
        case .unknownError: return "No idea what happend there..."              // internal
            
        case .invalidAPIKey: return "Please sign in again"                      // http - 400/401
        case .invalidCredentials: return "Invalid Credentials"                  // http - 400/401
            
        case .internalError: return "Oops! Something went wrong"                // internal
        case .serviceUnavailable: return "Oops! Seems like our server is down!" // http - 503
            
        case .notFound: return "Could not delete schedule"                      // error
        case .outOfSpace: return "You reached the limit of 20 saved schedules"  // error
        case .noMatchingUser: return "Username does not exist"                  // error
        case .userAlreadyExists: return "This username is already taken"        // error
        }
    }
    
    static func error(for statusCode: Int) -> APIError {
        switch statusCode {
        case 401, 400:
            let isLoggedIn =  UserDefaults.standard.string(forKey: "api_token") != nil
            return isLoggedIn ? .invalidAPIKey : .invalidCredentials
        case 500: return .serverError
        case 503: return .serviceUnavailable
        case 406: return .notAcceptable
        default: return .unknownError
        }
    }
}

// MARK: - URL Request

extension URLRequest {

    enum RequestType: String {
        case POST
        case GET
    }

    init?(url: String, content: [String: Any]=[:], type: RequestType, forceUnauthorized: Bool=false) {
        //  print(url)
        guard let url = URL(string: url),
            let jsonData = try? JSONSerialization.data(withJSONObject: content, options: .prettyPrinted) else {
                return nil
        }
        self.init(url: url)
        self.setValue("application/json", forHTTPHeaderField: "Content-Type")
        self.httpMethod = type.rawValue
        if !content.isEmpty {
            self.httpBody = jsonData
        }

        if let token = UserDefaults.standard.string(forKey: "api_token"),
            !forceUnauthorized {
            self.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    }

    func getJsonData(completionHandler: @escaping (Data) -> Void,
                     errorHandler: @escaping (APIError) -> Void) {
        let task = URLSession.shared.dataTask(with: self) { data, response, error in
            guard let data = data, error == nil else {                                   // check for fundamental networking error
                errorHandler(.networkError)
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {    // check for http errors
                errorHandler(APIError.error(for: httpStatus.statusCode))
                return
            }

            completionHandler(data)
            return
        }
        task.resume()
    }

}
