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
        
        var request:URLRequest = URLRequest(url: url, type: .POST)
        guard let jsonData = try? JSONSerialization.data(withJSONObject: ["username": user, "password": password], options: .prettyPrinted) else {
            completion(.InternalError)
            return
        }
        request.httpBody = jsonData
        
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
        guard let url = URL(string: "https://cse120-course-planner.herokuapp.com/api/users/user-info/") else {
            return
        }
        
        let request:URLRequest = URLRequest(url: url, type: .GET)
        request.getJsonData { (dict, err) in
            if (err != nil) {
                // Failed - invalid api key
                completion(err)
            } else {
                // Success - valid api key
                
                guard let uniqueID = dict!["unique_id"] as? String else {
                    completion(.InternalError)
                    return
                }
                
                UserDefaults.standard.set(uniqueID, forKey: "unique_id")
                
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
        
        var postContent = [ "username": user.trimmingCharacters(in: .whitespaces),
                            "password": password.trimmingCharacters(in: .whitespaces),
                            "first_name": first.trimmingCharacters(in: .whitespaces),
                            "last_name": last.trimmingCharacters(in: .whitespaces),
                            "name": "\(first) \(last)" ]
        if (email != nil) {
            postContent["email"] = email!.trimmingCharacters(in: .whitespaces)
        }
        
        
        var request:URLRequest = URLRequest(url: url, type: .POST)
        guard let jsonData = try? JSONSerialization.data(withJSONObject: postContent, options: .prettyPrinted) else {
            completion(.InternalError)
            return
        }
        request.httpBody = jsonData
        
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
    
    static func getSections(term: String, id: String, completion: @escaping ([Course]?, APIError?) -> ()) {
        guard let url = URL(string: "https://cse120-course-planner.herokuapp.com/api/courses/course-match/") else {
            completion(nil, .InternalError)
            return
        }
        
        let postContent = ["term": term, "course_list": [id]] as [String : Any]
        var request:URLRequest = URLRequest(url: url, type: .POST)
        guard let jsonData = try? JSONSerialization.data(withJSONObject: postContent, options: .prettyPrinted) else {
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
                guard let result = dict![id] as? Array<[String: Any?]> else {
                    completion(nil, .InternalError)
                    return
                }
                
                var courses:[Course] = []
                for courseDict in result {
                    courses.append(Course(courseDict))
                }
                
                courses.sort(by: { (c1, c2) -> Bool in
                    let id1 = c1.courseID
                    let id2 = c2.courseID
                    let s1 = String(id1.split(separator: "-")[2])
                    let s2 = String(id2.split(separator: "-")[2])
                    return s1 < s2
                })
                
                completion(courses, nil)
                return
            }
        }
    }
    
    static func searchCourseIDs(id: String, term: String?, completion: @escaping (Array<[String: String]>?, APIError?) -> ()) {
        guard let url = URL(string: "https://cse120-course-planner.herokuapp.com/api/courses/course-search?course=\(id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&term=\(term ?? "201810")") else {
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
                             openOnly: Bool=false,
                             completion: @escaping ([Schedule]?, APIError?) -> ()) {
        guard let url = URL(string: "https://cse120-course-planner.herokuapp.com/api/courses/schedule-search/") else {
            completion(nil, .InternalError)
            return
        }
        
        var request:URLRequest = URLRequest(url: url, type: .POST)
        var postContent = ["term": term, "course_list": courses] as [String : Any]
        postContent["search_full"] = openOnly ? "false" : "true"
        guard let jsonData = try? JSONSerialization.data(withJSONObject: postContent, options: .prettyPrinted) else {
            completion(nil, .InternalError)
            return
        }
        request.httpBody = jsonData
        
        request.getJsonData { (dict, err) in
            if (err != nil) {
                completion(nil, err!)
                return
            } else {
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
                    let courses:Dictionary<String, Dictionary<String, Dictionary<String, Any?>>>
                    guard let tempClasses = result[i]["schedule"] as? Dictionary<String, Dictionary<String, Dictionary<String, Any?>>> else {
                        completion(nil, .InternalError)
                        return
                    }
                    courses = tempClasses
                    let newSchedule = Schedule(info: info, courses: courses)
                    schedules.append(newSchedule)
                }
                completion(schedules, nil)
                return
            }
        }
    }
    
    static func getSavedSchedule(completion: @escaping ([Schedule]?, APIError?)->()) {
        guard let url = URL(string: "https://cse120-course-planner.herokuapp.com/api/users/schedule-dump/") else {
            completion(nil, .InternalError)
            return
        }
        let request:URLRequest = URLRequest(url: url, type: .GET)
        request.getJsonData { (dict, err) in
            if (err != nil) {
                completion(nil, err!)
                return
            } else {
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
                    let courses:Dictionary<String, Dictionary<String, Dictionary<String, Any?>>>
                    guard let tempClasses = result[i]["schedule"] as? Dictionary<String, Dictionary<String, Dictionary<String, Any?>>> else {
                        completion(nil, .InternalError)
                        return
                    }
                    courses = tempClasses
                    let newSchedule = Schedule(info: info, courses: courses)
                    schedules.append(newSchedule)
                }
                completion(schedules, nil)
                return
            }
        }
    }
    
    static func saveSchedule(term: String, crns: [String], completion: @escaping (APIError?)->()) {
        guard let url = URL(string: "https://cse120-course-planner.herokuapp.com/api/users/save-schedule/") else {
            completion(.InternalError)
            return
        }
        let postContent = ["term": term, "crns": crns] as [String: Any]
        var request:URLRequest = URLRequest(url: url, type: .POST)
        guard let jsonData = try? JSONSerialization.data(withJSONObject: postContent, options: .prettyPrinted) else {
            completion(.InternalError)
            return
        }
        request.httpBody = jsonData
        request.getJsonData { (dict, err) in
            if (err != nil) {
                completion(err!)
                return
            } else {
                guard dict!.contains(where: { (key, _) -> Bool in
                    return key == "success"
                }) else {
                    completion(.OutOfSpace)
                    return
                }
                completion(nil)
                return
            }
        }
    }
    
    static func deleteSchedule(term: String, crns: [String], completion: @escaping (APIError?)->()) {
        guard let url = URL(string: "https://cse120-course-planner.herokuapp.com/api/users/delete-schedule/") else {
            completion(.InternalError)
            return
        }
        let postContent = ["term": term, "crns": crns] as [String: Any]
        var request:URLRequest = URLRequest(url: url, type: .POST)
        guard let jsonData = try? JSONSerialization.data(withJSONObject: postContent, options: .prettyPrinted) else {
            completion(.InternalError)
            return
        }
        request.httpBody = jsonData
        request.getJsonData { (dict, err) in
            if (err != nil) {
                completion(err!)
                return
            } else {
                guard dict!.contains(where: { (key, _) -> Bool in
                    return key == "success"
                }) else {
                    completion(.NotFound)
                    return
                }
                completion(nil)
                return
            }
        }
    }
}
