//
//  RestAPI.swift
//  Lynx
//
//  Created by Maxime Moison on 3/7/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation
import UIKit

private enum API: String {
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

    var url: String {
        return API.endpointUrl + self.rawValue
    }

    func url(with parameters: [String: String]) -> String {

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
     request.getJsonData(completionHandler: { data in
     //Deal w/ data from response
     completionHandler()
     }, errorHandler: errorHandler)
     }*/

    static func login(user: String,
                      password: String,
                      completionHandler: @escaping () -> Void,
                      errorHandler: @escaping (APIError) -> Void) {
        let postContent = ["username": user, "password": password]
        guard let request = URLRequest(url: API.login.url, content: postContent, type: .POST) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { data in
            guard let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data),
                loginResponse.refreshKey != nil else {
                    errorHandler(.internalError)
                    return
            }
            UserSettings.accessKey = loginResponse.accessKey
            UserSettings.refreshKey = loginResponse.refreshKey
            
            RestAPI.getUserInfo(completionHandler: { _ in }, errorHandler: { _ in })
            
            DispatchQueue.main.async { completionHandler() }
        }, errorHandler: errorHandler)
    }

    static func refreshAPIKey(completionHandler: @escaping () -> Void,
                              errorHandler: @escaping (APIError) -> Void) {
        guard let postContent = ["refresh": UserSettings.refreshKey] as? [String: String],
            let request = URLRequest(url: API.refreshAPIKey.url, content: postContent, type: .POST) else {
                errorHandler(.internalError)
                return
        }
        request.getJsonData(completionHandler: { data in
            guard let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
                errorHandler(.internalError)
                return
            }
            UserSettings.accessKey = loginResponse.accessKey
            DispatchQueue.main.async { completionHandler() }
        }, errorHandler: errorHandler)
    }

    static func getUserInfo(completionHandler: @escaping (UserInformation) -> Void,
                            errorHandler: @escaping (APIError) -> Void) {
        guard let request = URLRequest(url: API.userInfo.url, type: .GET) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { data in
            guard let userInfo = try? JSONDecoder().decode(UserInformation.self, from: data) else {
                errorHandler(.internalError)
                return
            }
            UserSettings.userInformation = userInfo
            DispatchQueue.main.async { completionHandler(userInfo) }
        }, errorHandler: errorHandler)
    }

    static func changePassword(oldPass: String,
                               newPass: String,
                               completionHandler: @escaping () -> Void,
                               errorHandler: @escaping (APIError) -> Void) {
        let postContent = ["old_password": oldPass, "new_password": newPass]
        guard let request = URLRequest(url: API.changePassword.url, content: postContent, type: .POST) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { data in
            DispatchQueue.main.async { completionHandler() }
        }, errorHandler: errorHandler)
    }

    static func forgotPassword(user: String,
                               completionHandler: @escaping () -> Void,
                               errorHandler: @escaping (APIError) -> Void) {
        let postContent = ["username": user]
        guard let request = URLRequest(url: API.forgotPassword.url, content: postContent, type: .POST) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { data in
            DispatchQueue.main.async { completionHandler() }
        }, errorHandler: errorHandler)
    }

    static func signup(user: String,
                       password: String,
                       first: String,
                       last: String,
                       email: String?,
                       completionHandler: @escaping () -> Void,
                       errorHandler: @escaping (APIError) -> Void) {

        var postContent = [ "username": user.trimmingCharacters(in: .whitespaces),
                            "password": password.trimmingCharacters(in: .whitespaces),
                            "first_name": first.trimmingCharacters(in: .whitespaces),
                            "last_name": last.trimmingCharacters(in: .whitespaces)]
        if email != nil {
            postContent["email"] = email!.trimmingCharacters(in: .whitespaces)
        }
        guard let request = URLRequest(url: API.register.url, content: postContent, type: .POST) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { data in

            guard let response = try? JSONDecoder().decode(SignupResponse.self, from: data),
                let accessKey = response.accessKey,
                let refreshKey = response.refreshKey else {
                errorHandler(.internalError)
                return
            }
            UserSettings.accessKey = accessKey
            UserSettings.refreshKey = refreshKey
            DispatchQueue.main.async { completionHandler() }
        }, errorHandler: errorHandler)
    }

    static func getSections(term: String,
                            id: String,
                            completionHandler: @escaping ([Section]) -> Void,
                            errorHandler: @escaping (APIError) -> Void) {

        let postContent = ["term": term, "course_list": [id]] as [String: Any]
        guard let request = URLRequest(url: API.getSections.url, content: postContent, type: .POST) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { data in

            guard let response = try? JSONDecoder().decode([String: [Section]].self, from: data),
                var sections = response[id] else {
                    errorHandler(.internalError)
                    return
            }

            sections.sort(by: { (section1, section2) -> Bool in
                let id1 = section1.courseID
                let id2 = section2.courseID
                let sectionNumber1 = String(id1.split(separator: "-")[2])
                let sectionNumber2 = String(id2.split(separator: "-")[2])
                return sectionNumber1 < sectionNumber2
            })
            DispatchQueue.main.async { completionHandler(sections) }
        }, errorHandler: errorHandler)
    }

    static func searchCourseIDs(id: String,
                                term: String,
                                completionHandler: @escaping ([CourseSearchResult]) -> Void,
                                errorHandler: @escaping (APIError) -> Void) {

        guard let courseID = id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let request = URLRequest(url: API.searchCourseIDs.url(with: ["course": courseID, "term": term]), type: .GET) else {
                errorHandler(.internalError)
                return
        }
        request.getJsonData(completionHandler: { data in

            guard var searchResults = try? JSONDecoder().decode([CourseSearchResult].self, from: data) else {
                errorHandler(.internalError)
                return
            }

            searchResults.sort(by: { (course1, course2) -> Bool in
                let course1 = course1.name.split(separator: "-")
                let course2 = course2.name.split(separator: "-")

                if course1[0] == course2[0] {
                    let n1 = Int(course1[1].trimmingCharacters(in: CharacterSet.decimalDigits.inverted)) ?? 0
                    let n2 = Int(course2[1].trimmingCharacters(in: CharacterSet.decimalDigits.inverted)) ?? 0
                    return n1 < n2
                }
                return course1[0] < course2[0]
            })

            DispatchQueue.main.async { completionHandler(searchResults) }
        }, errorHandler: errorHandler)
    }

    static func getTerms(completionHandler: @escaping ([String]) -> Void,
                         errorHandler: @escaping (APIError) -> Void) {

        guard let request = URLRequest(url: API.getTerms.url, type: .GET) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { data in

            guard var terms = try? JSONDecoder().decode([String].self, from: data) else {
                errorHandler(.internalError)
                return
            }

            terms.sort(by: { (s1, s2) -> Bool in
                if s1.prefix(4) == s2.prefix(4) {
                    return s1.suffix(2) > s2.suffix(2)
                }
                return s1.prefix(4) > s2.prefix(4)
            })
            DispatchQueue.main.async { completionHandler(terms) }
        }, errorHandler: errorHandler)
    }

    static func getSchedules(term: String,
                             courses: [String],
                             openOnly: Bool=false,
                             badCRNs: [String]?=nil,
                             completionHandler: @escaping ([Schedule]) -> Void,
                             errorHandler: @escaping (APIError) -> Void) {

        var postContent = ["term": term, "course_list": courses] as [String: Any]
        postContent["search_full"] = openOnly ? "false" : "true"
        if badCRNs != nil {
            postContent["bad_crns"] = badCRNs!
        }
        guard let request = URLRequest(url: API.getSchedules.url, content: postContent, type: .POST) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { data in
            guard let schedules = try? JSONDecoder().decode([Schedule].self, from: data) else {
                errorHandler(.internalError)
                return
            }
            DispatchQueue.main.async { completionHandler(schedules) }
        }, errorHandler: errorHandler)
    }

    static func getSavedSchedule(term: String,
                                 completionHandler: @escaping ([Schedule]) -> Void,
                                 errorHandler: @escaping (APIError) -> Void) {

        guard let request = URLRequest(url: API.getSavedSchedules.url(with: ["term": term]), type: .GET) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { data in
            guard let schedules = try? JSONDecoder().decode([Schedule].self, from: data) else {
                errorHandler(.internalError)
                return
            }
            DispatchQueue.main.async { completionHandler(schedules) }
        }, errorHandler: errorHandler)
    }

    static func saveSchedule(term: String,
                             crns: [String],
                             completionHandler: @escaping () -> Void,
                             errorHandler: @escaping (APIError) -> Void) {

        let postContent: [String: Any] = ["term": term, "crns": crns]
        guard let request = URLRequest(url: API.saveSchedule.url, content: postContent, type: .POST) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { data in
            DispatchQueue.main.async { completionHandler() }
        }, errorHandler: errorHandler)
    }

    static func deleteSchedule(term: String,
                               crns: [String],
                               customEvents: [CustomEvent],
                               completionHandler: @escaping () -> Void,
                               errorHandler: @escaping (APIError) -> Void) {

        guard let customEventsData = try? JSONEncoder().encode(customEvents),
        let customEventJson = try? JSONSerialization.jsonObject(with: customEventsData, options: []) else {
            errorHandler(.internalError)
            return
        }
        let postContent: [String: Any] = ["term": term, "crns": crns, "custom_events": customEventJson]
        guard let request = URLRequest(url: API.deleteSchedule.url, content: postContent, type: .POST) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { data in
            DispatchQueue.main.async { completionHandler() }
        }, errorHandler: errorHandler)
    }

    static func getProfileImage(imageURL: String,
                                completionHandler: @escaping (UIImage) -> Void,
                                errorHandler: @escaping (APIError) -> Void) {
        guard let request = URLRequest(url: imageURL, type: .GET, forceUnauthorized: true) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { data in
            guard let image = UIImage(data: data) else {
                errorHandler(.internalError)
                return
            }
            completionHandler(image)
        }, errorHandler: errorHandler)
    }
}
