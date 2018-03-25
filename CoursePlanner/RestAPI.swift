//
//  RestAPI.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/7/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation

class RestAPI {
    
    static func login(user: String,
                      password: String,
                      completion: @escaping (APIError?) -> ()) {
        guard let url = URL(string: "https://cse120-course-planner.herokuapp.com/api/auth/token/obtain") else {
            completion(.InternalError)
            return
        }
        let request:URLRequest = URLRequest(url: url, type: .POST, dictionary: [ "username": user, "password": password ])
        request.getJsonData { (dict, err) in
            if (err != nil) {
                completion(err!)
                return
            } else {
                // Save to application settings
                guard let token = dict!["access"] as? String else {
                    completion(.InternalError)
                    return
                }
                UserDefaults.standard.set(token, forKey: "api_token")
                completion(nil)
                return
            }
        }
    }
    
    static func checkAPIKey(completion: @escaping (APIError?) -> ()) {
        guard let url = URL(string: "https://cse120-course-planner.herokuapp.com/api/login/") else {
            return
        }
        
        let request:URLRequest = URLRequest(url: url, type: .GET)
        request.getJsonData { (dict, err) in
            if (err != nil) {
                // Failed - invalid api key
                completion(err)
            } else {
                // Success - valid api key
                completion(nil)
            }
        }
    }
    
    static func refreshApplicationKey() throws -> String? {
        let semaphore = DispatchSemaphore(value: 1)
        var token:String?
        var error:APIError?
        guard let url = URL(string: "https://cse120-course-planner.herokuapp.com/api/auth/token/refresh") else {
            return nil
        }
        
        let request:URLRequest = URLRequest(url: url, type: .POST, dictionary: [ "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwNzUzOTkzMiwianRpIjoiZGM3N2EyMDExMTE2NGEwZGI0YjIzOGE0NWU5ZWUxZTMiLCJ1c2VyX2lkIjo4fQ.bFawovm0b01mfzGgO-DmqXzENg7DeLzBCFKoAJV4LP4" ])
        request.getJsonData { (dict, err) in
            if (err == nil) {
                // Success - valid api key
                token = "Bearer \(dict!["access"] ?? "")"
            } else {
                error = err
            }
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        if (error != nil) {
            throw error!
        }
        return token
    }
    
    static func register(user: String,
                         password: String,
                         first: String,
                         last: String,
                         email: String?,
                         completion: @escaping (APIError?) -> ()) {
        guard let url = URL(string: "https://cse120-course-planner.herokuapp.com/api/register/") else {
            completion(.InternalError)
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
        
        var request:URLRequest = URLRequest(url: url, type: .POST, dictionary: postContent)
        
        let token:String
        do {
            token = (try refreshApplicationKey())!
        } catch {
            completion(error as? APIError)
            return
        }
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.getJsonData { (dict, err) in
            if (err != nil) {
                completion(err)
            } else {
                // Save to application settings
                guard let keys = dict!["api_keys"]! as? Dictionary<String, String> else {
                    completion(.InternalError)
                    return
                }
                guard let token = keys["access"] else {
                    completion(.InternalError)
                    return
                }
                UserDefaults.standard.set(token, forKey: "api_token")
                completion(nil)
            }
        }
    }
    
    static func searchCourseIDs(id: String, term: String?, completion: @escaping (Array<String>?, APIError?) -> ()) {
        guard let url = URL(string: "https://cse120-course-planner.herokuapp.com/api/courses/course-search?course=\(id)&term=\(term ?? "201810")") else {
            completion(nil, .InternalError)
            return
        }
        let request:URLRequest = URLRequest(url: url, type: .GET)
        request.getJsonData { (dict, err) in
            if (err != nil) {
                completion(nil, err!)
                return
            } else {
                // Save to application settings
                guard let result = dict!["result"] as? Array<String> else {
                    completion(nil, .InternalError)
                    return
                }
                completion(result, nil)
                return
            }
        }
    }

    static func getTerms(completion: @escaping (Array<String>?, APIError?) -> ()) {
        guard let url = URL(string: "https://cse120-course-planner.herokuapp.com/api/courses/get-terms/") else {
            completion(nil, .InternalError)
            return
        }
        let request:URLRequest = URLRequest(url: url, type: .GET)
        request.getJsonData { (dict, err) in
            if (err != nil) {
                completion(nil, err!)
                return
            } else {
                // Save to application settings
                guard let result = dict!["result"] as? Array<String> else {
                    completion(nil, .InternalError)
                    return
                }
                completion(result, nil)
                return
            }
        }
    }
    
    static func getSchedules(term: String,
                             courses: Array<String>,
                             earliest: String?=nil,
                             latest: String?=nil,
                             gapsAscending: Bool?=nil,
                             daysAscending: Bool?=nil,
                             completion: @escaping ([Schedule]?, APIError?) -> ()) {
        guard let url = URL(string: "https://cse120-course-planner.herokuapp.com/api/courses/schedule-search/") else {
            completion(nil, .InternalError)
            return
        }
        var request:URLRequest = URLRequest(url: url, type: .POST)
        
        var dict = ["term": term, "course_list": courses] as [String : Any]
        if (earliest != nil) {
            dict["earliest_time"] = earliest!
        }
        if (earliest != nil) {
            dict["latest_time"] = latest!
        }
        if (gapsAscending != nil) {
            dict["gaps"] = gapsAscending! ? "asc" : "desc"
        }
        if (daysAscending != nil) {
            dict["days"] = daysAscending! ? "asc" : "desc"
        }
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) else {
            completion(nil, .InternalError)
            return
        }
        
        request.httpBody = jsonData
        
        request.getJsonData { (dict, err) in
            if (err != nil) {
                completion(nil, err!)
                return
            } else {
                // Save to application settings
                guard let result = dict!["result"] as? Array<Dictionary<String, Any>> else {
                    completion(nil, .InternalError)
                    return
                }
                
                var schedules:[Schedule] = []
                for i in 0..<result.count {
                    let info:Dictionary<String, Any>
                    guard let tempInfo = result[i]["info"]! as? Dictionary<String, Any> else {
                        completion(nil, .InternalError)
                        return
                    }
                    info = tempInfo
                    let classes:Dictionary<String, Dictionary<String, Dictionary<String, Any?>>>
                    guard let tempClasses = result[i]["schedule"] as? Dictionary<String, Dictionary<String, Dictionary<String, Any?>>> else {
                        completion(nil, .InternalError)
                        return
                    }
                    classes = tempClasses
                    let newSchedule = Schedule(info: info, classes: classes)
                    schedules.append(newSchedule)
                }
                completion(schedules, nil)
                return
            }
        }
    }
}
