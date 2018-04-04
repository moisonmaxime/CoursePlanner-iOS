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
                guard let refresh = dict!["refresh"] as? String else {
                    completion(.InternalError)
                    return
                }
                guard let access = dict!["access"] as? String else {
                    completion(.InternalError)
                    return
                }
                UserDefaults.standard.set(access, forKey: "api_token")
                UserDefaults.standard.set(refresh, forKey: "refresh_token")
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
    
    /*
     static func refreshApplicationKey(completion: @escaping (APIError?) -> ()) {
     guard let url = URL(string: "https://cse120-course-planner.herokuapp.com/api/auth/token/refresh") else {
     completion(.InternalError)
     return
     }
     let request:URLRequest = URLRequest(url: url, type: .POST, dictionary: [ "refresh": UserDefaults.standard.string(forKey: "refresh_token")! ])
     request.getJsonData { (dict, err) in
     if (err != nil) {
     completion(err!)
     return
     } else {
     // Save to application settings
     print(dict)
     //                guard let refresh = dict!["refresh"] as? String else {
     //                    completion(.InternalError)
     //                    return
     //                }
     guard let access = dict!["access"] as? String else {
     completion(.InternalError)
     return
     }
     UserDefaults.standard.set(access, forKey: "api_token")
     // UserDefaults.standard.set(refresh, forKey: "refresh_token")
     completion(nil)
     return
     }
     }
     }
     */
    
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
        
        let request:URLRequest = URLRequest(url: url, type: .POST, dictionary: postContent)
        
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
    
    static func getSections(term: String, id: String, completion: @escaping (Array<[String: Any?]>?, APIError?) -> ()) {
        guard let url = URL(string: "https://cse120-course-planner.herokuapp.com/api/courses/course-match/") else {
            completion(nil, .InternalError)
            return
        }
        
        let dict = ["term": term, "course_list": [id]] as [String : Any]
        
        var request:URLRequest = URLRequest(url: url, type: .POST)
        
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
                guard var result = dict![id] as? Array<[String: Any?]> else {
                    completion(nil, .InternalError)
                    return
                }
                result.sort(by: { (d1, d2) -> Bool in
                    let id1 = d1["course_id"] as? String
                    let id2 = d2["course_id"] as? String
                    let s1 = String((id1?.split(separator: "-")[2])!)
                    let s2 = String((id2?.split(separator: "-")[2])!)
                    return s1 < s2
                })
                completion(result, nil)
                return
            }
        }
    }
    
    static func searchCourseIDs(id: String, term: String?, completion: @escaping (Array<[String: String]>?, APIError?) -> ()) {
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
                guard let result = dict!["result"] as? Array<[String: String]> else {
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
        
        dict["search_full"] = "true"
        
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
