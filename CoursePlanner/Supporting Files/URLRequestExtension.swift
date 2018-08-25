//
//  URLRequestExtension.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/9/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation

// MARK: - API Error

enum APIError {
    case networkError
    case serverError
    case invalidAPIKey
    case invalidCredentials
    case internalError
    case serviceUnavailable
    case notFound
    case outOfSpace
    case noMatchingUser
    case userAlreadyExists
    case unknownError
}

extension APIError {
    var message: String {
        switch self {
        case .serverError: return "Server Error"
        case .networkError: return "Check your internet connection"
        case .invalidAPIKey: return "Please sign in again"
        case .invalidCredentials: return "Invalid Credentials"
        case .internalError: return "Oops! Something went wrong"
        case .serviceUnavailable: return "Oops! Seems like our server is down!"
        case .notFound: return "Could not delete schedule"
        case .outOfSpace: return "You reached the limit of 20 saved schedules"
        case .noMatchingUser: return "Username does not exist"
        case .userAlreadyExists: return "This username is already taken"
        case .unknownError: return "No idea what happend there..."
        }
    }
    static func error(for statusCode: Int) -> APIError {
        if statusCode == 401 || statusCode == 400 {
            if let _ = UserDefaults.standard.string(forKey: "api_token") {
                return .invalidAPIKey
            } else {
                return .invalidCredentials
            }
        } else if statusCode == 500 {
            return .serverError
        } else if statusCode == 500 {
            return .serviceUnavailable
        }
        return .unknownError
    }
}

// MARK: - URL Request

extension URLRequest {
    
    enum RequestType:String {
        case POST = "POST"
        case GET = "GET"
    }
    
    init?(url: String, content:[String:Any]=[:], type: RequestType, forceUnauthorized: Bool=false) {
        print(url)
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
        
        let token = UserDefaults.standard.string(forKey: "api_token")
        if (token != nil && !forceUnauthorized) {
            self.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        }
    }
    
    func getJsonData(completionHandler: @escaping (Dictionary<String, Any>)->(), errorHandler: @escaping (APIError)->()) {
        let task = URLSession.shared.dataTask(with: self) { data, response, error in
            guard let data = data, error == nil else {                                   // check for fundamental networking error
                errorHandler(.networkError)
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {    // check for http errors
                // print("HttpCode: \(httpStatus.statusCode)")
                errorHandler(APIError.error(for: httpStatus.statusCode))
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {      // extract response data
                if let dict = json as? Dictionary<String, Any> {
                    print(dict)
                    completionHandler(dict)
                    return
                } else if let array = json as? Array<Any> {
                    let dict = ["result": array]
                    print(dict)
                    completionHandler(dict)
                    return
                }
            }
            errorHandler(.internalError)
            return
        }
        task.resume()
    }
    
}
