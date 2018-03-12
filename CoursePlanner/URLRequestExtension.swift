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
    
    init(url: URL, type: RequestType, dictionary: Dictionary<String, String>) {
        self.init(url: url)
        self.setValue("application/json", forHTTPHeaderField: "Content-Type")
        self.httpMethod = type.rawValue
        let json = dictionary.toJSONString()
        self.httpBody = json.data(using: .utf8)
    }
    
    func getJsonData(completion: @escaping (Dictionary<String, Any>?, APIError?)->()) {
        let task = URLSession.shared.dataTask(with: self) { data, response, error in
            guard let data = data, error == nil else {                                   // check for fundamental networking error
                completion(nil, .NetworkError)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {    // check for http errors
                var requestError:APIError
                
                switch (httpStatus.statusCode) {
                case 401:
                    requestError = .Unauthorized
                    break
                case 400:
                    requestError = .Unauthorized
                    break
                default:
                    requestError = .Unknown
                    break
                }
                
                completion(nil, requestError)
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if let dict = json as? Dictionary<String, Any> {
                    completion(dict, nil)
                    return
                } else {
                    completion(nil, .DictionaryCreationFailed)
                    return
                }
            } else {
                completion(nil, APIError.JSONSerializationFailed)
                return
            }
        }
        
        task.resume()
    }
}
