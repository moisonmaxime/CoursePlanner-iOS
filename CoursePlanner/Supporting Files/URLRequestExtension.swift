//
//  URLRequestExtension.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/9/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation

extension URLRequest {
    
    enum RequestType:String {
        case POST = "POST"
        case GET = "GET"
    }
    
    init(url: URL, type: RequestType) {
        self.init(url: url)
        self.setValue("application/json", forHTTPHeaderField: "Content-Type")
        self.httpMethod = type.rawValue
        
        let token = UserDefaults.standard.string(forKey: "api_token")
        if (token != nil) {
            self.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        }
    }
    
    func getJsonData(completion: @escaping (Dictionary<String, Any>?, APIError?)->()) {
        let task = URLSession.shared.dataTask(with: self) { data, response, error in
            guard let data = data, error == nil else {                                   // check for fundamental networking error
                completion(nil, .NetworkError)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {    // check for http errors
                // debugPrint("HttpCode: \(httpStatus.statusCode)")
                if (httpStatus.statusCode == 401 || httpStatus.statusCode == 400) {
                    if (UserDefaults.standard.string(forKey: "api_token") != nil) {
                        completion(nil, .InvalidAPIKey)
                    } else {
                        completion(nil, .InvalidCredentials)
                    }
                    return
                } else if (httpStatus.statusCode == 500) {
                    completion(nil, .ServerError)
                    return
                } else if (httpStatus.statusCode == 500) {
                    completion(nil, .ServiceUnavailable)
                    return
                }
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if let dict = json as? Dictionary<String, Any> {
                    completion(dict, nil)
                    return
                } else if let array = json as? Array<Any> {
                    let dict = ["result": array]
                    completion(dict, nil)
                    return
                }
            }
            completion(nil, .InternalError)
            return
        }
        
        task.resume()
    }
    
}
