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
    case URLCreationFailed
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
            completion(false, .URLCreationFailed)
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
    
    static func checkAPIKey(completion: @escaping(Bool) -> ()) {
        guard let url = URL(string: "https://cse120-course-planner.herokuapp.com/api/login") else {
            completion(false)
            return
        }
        
        let request:URLRequest = URLRequest(url: url, type: .GET)
        request.getJsonData { (dict, err) in
            if (err != nil) {
                // Failed
                completion(false)
                return
            } else {
                // Success
                completion(true)
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
        guard let url = URL(string: "https://cse120-course-planner.herokuapp.com/api/register/") else {
            completion(false, .URLCreationFailed)
            return
        }
        
        var postContent = [ "username": user,
                            "password": password,
                            "first_name": first,
                            "last_name": last,
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
                guard let keys = dict!["api_keys"]! as? Dictionary<String, String> else {
                    completion(false, .DictionaryCreationFailed)
                    return
                }
                guard let token = keys["access"] else {
                    completion(false, .TokenReadFailed)
                    return
                }
                UserDefaults.standard.set(token, forKey: "api_token")
                print(token)
                completion(true, nil)
            }
        }
    }

}
