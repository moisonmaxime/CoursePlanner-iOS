//
//  RestAPI.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/7/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation

enum APIError {
    case NetworkError               // Internal Errors
    case DictionaryCreationFailed
    case JSONSerializationFailed
    case TokenReadFailed
    
    case Unknown                    // Server Errors
    case Unauthorized
    
    case WrongCredentials   // Not yet active
    case WrongAPIKey
}



class RestAPI {
    
    static func login(user: String,
                      password: String,
                      completion: @escaping (Bool, APIError?) -> ()) {
        guard let url = URL(string: "https://cse120-course-planner.herokuapp.com/api/auth/token/obtain") else {
            print("Error: Could not create URL")
            completion(false, nil)
            return
        }
        let request:URLRequest = URLRequest(url: url, type: .POST, dictionary: [ "username": user, "password": password ])
        request.getJsonData { (dict, err) in
            if (err != nil) {
                completion(false, err)
                return
            } else {
                // Save to application settings
                
                guard let token = dict!["access"] as? String else {
                    completion(false, .TokenReadFailed)
                    return
                }
                UserDefaults.standard.set(token, forKey: "api_token")
                print(token)
                completion(true, nil)
                return
            }
        }
    }
    
    static func register(user: String,
                         password: String,
                         first: String,
                         last: String,
                         email: String?,
                         completion: @escaping (Bool, APIError?) -> ()) {
        guard let url = URL(string: "https://cse120-course-planner.herokuapp.com/***") else {
            print("Error: Could not create URL")
            completion(false, nil)
            return
        }
        
        var postContent = [ "username": user,
                            "password": password,
                            "firstname": first,
                            "lastname": last,
                            "name": "\(first) \(last)" ]
        if (email != nil) {
            postContent["email"] = email!
        }
        
        let request:URLRequest = URLRequest(url: url, type: .POST, dictionary: postContent)
        request.getJsonData { (dict, err) in
            if (err != nil) {
                completion(false, err)
            } else {
                // Save to application settings
                print(dict!["access"] as! String)
                completion(true, nil)
            }
        }
    }

}
