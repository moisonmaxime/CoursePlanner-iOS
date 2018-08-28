//
//  RestAPI.swift
//  Lynx
//
//  Created by Maxime Moison on 3/7/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation

private enum API: String  {
    case login = "auth/token/obtain"
    case refreshAPIKey = "auth/token/refresh"
    case userInfo = "users/user-info/"
    case changePassword = "users/change-password/"
    case forgotPassword = "users/forgot-password/"
    case register = "register/"
    case getSections = "courses/course-match/"
    case searchCourseIDs = "courses/course-search?"
    case getTerms = "courses/get-terms/"
    case getSchedules = "courses/schedule-search/"
    case getSavedSchedules = "users/schedule-dump/?"
    case saveSchedule = "users/save-schedule/"
    case deleteSchedule = "users/delete-schedule/"
}

extension API {
    private static let endpointUrl = "https://cse120-course-planner.herokuapp.com/api/"
    
    var url:String {
        return API.endpointUrl + self.rawValue
    }
    
    func url(with parameters: [String:String]) -> String {
        
        let parametersString = parameters.map { (parameterKey, parameter) -> String in
            return "\(parameterKey)=\(parameter)"
        }.joined(separator: "&")
        
        return API.endpointUrl + self.rawValue + parametersString
    }
}

class RestAPI {
    
    /*
     - Template for API Request -
     static func doSomething(completionHandler: @escaping ()->(), errorHandler: @escaping (APIError) -> ()) {
     let postContent:[String: Any] = [:]
     guard let request = URLRequest(url: API.login.url, content: postContent, type: .POST) else {
     errorHandler(.internalError)
     return
     }
     request.getJsonData(completionHandler: { dict in
     //Deal w/ data from response
     completionHandler()
     }, errorHandler: errorHandler)
     }*/
    
    
    static func login(user: String,
                      password: String,
                      completionHandler: @escaping ()->(),
                      errorHandler: @escaping (APIError)->()) {
        let postContent = ["username": user, "password": password]
        guard let request = URLRequest(url: API.login.url, content: postContent, type: .POST) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { dict in
            guard let refresh = dict["refresh"] as? String,
                let access = dict["access"] as? String else {
                    errorHandler(.internalError)
                    return
            }
            UserDefaults.standard.set(access, forKey: "api_token")
            UserDefaults.standard.set(refresh, forKey: "refresh_token")
            DispatchQueue.main.async { completionHandler() }
        }, errorHandler: errorHandler)
    }
    
    
    static func refreshAPIKey(completionHandler: @escaping ()->(),
                              errorHandler: @escaping (APIError) -> ()) {
        guard let postContent = ["refresh": UserDefaults.standard.string(forKey: "refresh_token")] as? [String: String],
            let request = URLRequest(url: API.refreshAPIKey.url, content: postContent, type: .POST) else {
                errorHandler(.internalError)
                return
        }
        request.getJsonData(completionHandler: { dict in
            guard let access = dict["access"] as? String else {
                errorHandler(.internalError)
                return
            }
            UserDefaults.standard.set(access, forKey: "api_token")
            DispatchQueue.main.async { completionHandler() }
        }, errorHandler: errorHandler)
    }
    
    
    
    static func getUserInfo(completionHandler: @escaping ([String:String])->(),
                            errorHandler: @escaping (APIError) -> ()) {
        guard let request = URLRequest(url: API.userInfo.url, type: .GET) else {
                errorHandler(.internalError)
                return
        }
        request.getJsonData(completionHandler: { dict in
            guard let username = dict["username"] as? String else {
                errorHandler(.internalError)
                return
            }
            guard let name = dict["name"] as? String else {
                errorHandler(.internalError)
                return
            }
            let userInfo = ["username": username, "name": name]
            DispatchQueue.main.async { completionHandler(userInfo) }
        }, errorHandler: errorHandler)
    }
    
    
    
    static func changePassword(oldPass: String,
                               newPass: String,
                               completionHandler: @escaping ()->(),
                               errorHandler: @escaping (APIError) -> ()) {
        let postContent = ["old_password": oldPass, "new_password": newPass]
        guard let request = URLRequest(url: API.changePassword.url, content: postContent, type: .POST) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { dict in
            if let failure = dict["fail"] as? String {
                let error:APIError = failure == "password_incorrect" ? .invalidCredentials : .serverError
                errorHandler(error)
                return
            }
            DispatchQueue.main.async { completionHandler() }
        }, errorHandler: errorHandler)
    }
    
    
    
    static func forgotPassword(user: String,
                               completionHandler: @escaping ()->(),
                               errorHandler: @escaping (APIError) -> ()) {
        let postContent = ["username": user]
        guard let request = URLRequest(url: API.forgotPassword.url, content: postContent, type: .POST) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { dict in
            guard let success = dict["success"] as? Bool else {
                errorHandler(.internalError)
                return
            }
            guard success else {
                errorHandler(.noMatchingUser)
                return
            }
            DispatchQueue.main.async { completionHandler() }
        }, errorHandler: errorHandler)
    }
    
    
    
    static func register(user: String,
                         password: String,
                         first: String,
                         last: String,
                         email: String?,
                         completionHandler: @escaping ()->(),
                         errorHandler: @escaping (APIError) -> ()) {
        
        var postContent = [ "username": user.trimmingCharacters(in: .whitespaces),
                            "password": password.trimmingCharacters(in: .whitespaces),
                            "first_name": first.trimmingCharacters(in: .whitespaces),
                            "last_name": last.trimmingCharacters(in: .whitespaces),
                            "name": "\(first) \(last)" ]
        if (email != nil) {
            postContent["email"] = email!.trimmingCharacters(in: .whitespaces)
        }
        guard let request = URLRequest(url: API.register.url, content: postContent, type: .POST) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { dict in
            if let error = dict["error"] as? String {
                if (error == "User Already Exists") {
                    errorHandler(.userAlreadyExists)
                    return
                }
                errorHandler(.serverError)
                return
            }
            
            guard let keys = dict["api_keys"] as? Dictionary<String, String> else {
                errorHandler(.internalError)
                return
            }
            guard let token = keys["access"] else {
                errorHandler(.internalError)
                return
            }
            UserDefaults.standard.set(token, forKey: "api_token")
            DispatchQueue.main.async { completionHandler() }
        }, errorHandler: errorHandler)
    }
    
    
    
    static func getSections(term: String,
                            id: String,
                            completionHandler: @escaping ([Course])->(),
                            errorHandler: @escaping (APIError) -> ()) {
        
        let postContent = ["term": term, "course_list": [id]] as [String : Any]
        guard let request = URLRequest(url: API.getSections.url, content: postContent, type: .POST) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { dict in
            guard let result = dict[id] as? Array<[String: Any?]> else {
                errorHandler(.internalError)
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
            DispatchQueue.main.async { completionHandler(courses) }
        }, errorHandler: errorHandler)
    }
    
    
    
    static func searchCourseIDs(id: String,
                                term: String,
                                completionHandler: @escaping ([[String: String]])->(),
                                errorHandler: @escaping (APIError) -> ()) {
        
        guard let courseID = id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let request = URLRequest(url: API.searchCourseIDs.url(with: ["course": courseID, "term": term]), type: .GET) else {
                errorHandler(.internalError)
                return
        }
        request.getJsonData(completionHandler: { dict in
            guard let result = dict["result"] as? Array<[String: String]> else {
                errorHandler(.internalError)
                return
            }
            DispatchQueue.main.async { completionHandler(result) }
        }, errorHandler: errorHandler)
    }
    
    
    
    static func getTerms(completionHandler: @escaping ([String])->(),
                         errorHandler: @escaping (APIError) -> ()) {
        
        guard let request = URLRequest(url: API.getTerms.url, type: .GET) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { dict in
            guard var result = dict["result"] as? Array<String> else {
                errorHandler(.internalError)
                return
            }
            result.sort(by: { (s1, s2) -> Bool in
                if (s1.prefix(4) == s2.prefix(4)) {
                    return s1.suffix(2) > s2.suffix(2)
                }
                return s1.prefix(4) > s2.prefix(4)
            })
            UserDefaults.standard.set(result, forKey: "terms")
            DispatchQueue.main.async { completionHandler(result) }
        }, errorHandler: errorHandler)
    }
    
    
    
    static func getSchedules(term: String,
                             courses: Array<String>,
                             openOnly: Bool=false,
                             badCRNs: [String]?=nil,
                             completionHandler: @escaping ([Schedule])->(),
                             errorHandler: @escaping (APIError) -> ()) {
        
        var postContent = ["term": term, "course_list": courses] as [String : Any]
        postContent["search_full"] = openOnly ? "false" : "true"
        if (badCRNs != nil) {
            postContent["bad_crns"] = badCRNs!
        }
        guard let request = URLRequest(url: API.getSchedules.url, content: postContent, type: .POST) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { dict in
            guard let result = dict["result"] as? [[String: Any]] else {
                errorHandler(.internalError)
                return
            }
            
            var schedules:[Schedule] = []
            for i in 0..<result.count {
                guard let info = result[i]["info"]! as? [String: Any] else {
                    errorHandler(.internalError)
                    return
                }
                guard let courses = result[i]["schedule"] as? [String: [String: Any?]] else {
                    errorHandler(.internalError)
                    return
                }
                let newSchedule = Schedule(info: info, courses: courses)
                schedules.append(newSchedule)
            }
            DispatchQueue.main.async { completionHandler(schedules) }
        }, errorHandler: errorHandler)
    }
    
    
    
    static func getSavedSchedule(term: String,
                                 completionHandler: @escaping ([Schedule])->(),
                                 errorHandler: @escaping (APIError) -> ()) {
        
        guard let request = URLRequest(url: API.getSavedSchedules.url(with: ["term" : term]), type: .GET) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { dict in
            guard let result = dict["result"] as? Array<Dictionary<String, Any>> else {
                errorHandler(.internalError)
                return
            }
            
            var schedules:[Schedule] = []
            for index in 0..<result.count {
                guard let info = result[index]["info"]! as? Dictionary<String, Any> else {
                    errorHandler(.internalError)
                    return
                }
                guard let courses = result[index]["schedule"] as? Dictionary<String, Dictionary<String, Dictionary<String, Any?>>> else {
                    errorHandler(.internalError)
                    return
                }
                let newSchedule = Schedule(info: info, courses: courses)
                schedules.append(newSchedule)
            }
            DispatchQueue.main.async { completionHandler(schedules) }
        }, errorHandler: errorHandler)
    }
    
    
    
    static func saveSchedule(term: String,
                             crns: [String],
                             completionHandler: @escaping ()->(),
                             errorHandler: @escaping (APIError) -> ()) {
        
        let postContent:[String: Any] = ["term": term, "crns": crns]
        guard let request = URLRequest(url: API.saveSchedule.url, content: postContent, type: .POST) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { dict in
            guard dict.keys.contains("success") else {
                errorHandler(.outOfSpace)
                return
            }
            DispatchQueue.main.async { completionHandler() }
        }, errorHandler: errorHandler)
    }
    
    
    
    static func deleteSchedule(term: String,
                               crns: [String],
                               completionHandler: @escaping ()->(),
                               errorHandler: @escaping (APIError) -> ()) {
        
        let postContent:[String: Any] = ["term": term, "crns": crns]
        guard let request = URLRequest(url: API.deleteSchedule.url, content: postContent, type: .POST) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { dict in
            guard dict.keys.contains("success") else {
                errorHandler(.notFound)
                return
            }
            DispatchQueue.main.async { completionHandler() }
        }, errorHandler: errorHandler)
    }
    
    
    /*
    static func register(username: String, password: String, term: String, crns: [String], completion: @escaping (APIError?, String?)->()) {
        
        guard let url = URL(string: "\(apiURL)courses/course-register/") else {
            completion(.internalError, nil)
            return
        }
        let postContent = ["term": term, "crns": crns, "username": username, "password": password] as [String: Any]
        var request:URLRequest = URLRequest(url: url, type: .POST)
        guard let jsonData = try? JSONSerialization.data(withJSONObject: postContent, options: .prettyPrinted) else {
            completion(.internalError, nil)
            return
        }
        request.httpBody = jsonData
        request.getJsonData { (dict, err) in
            if (err != nil) {
                completion(err!, nil)
                return
            } else {
                guard let result = dict! as? [String: String] else {
                    completion(.internalError, nil)
                    return
                }
                print(result)
                guard !result.keys.contains("reg_time") else {
                    completion(nil, dict!["reg_time"] as? String)
                    return
                }
                guard !result.keys.contains("login") else {
                    completion(nil, "Invalid UC Merced Credentials")
                    return
                }
                completion(nil, nil)
                return
            }
        }
    }*/
}
