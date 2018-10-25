//
//  UserSettings.swift
//  Lynx
//
//  Created by Maxime Moison on 10/24/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation

class UserSettings {
    
    static var isLoggedIn: Bool {
        return UserSettings.accessKey != nil
    }
    
    static var accessKey: String? {
        get {
            return UserDefaults.standard.string(forKey: "api_token")
        }
        set {
            if let newKey = newValue {
                UserDefaults.standard.set(newKey, forKey: "api_token")
            } else {
                UserDefaults.standard.removeObject(forKey: "api_token")
            }
        }
    }
    
    static var refreshKey: String? {
        get {
            return UserDefaults.standard.string(forKey: "refresh_token")
        }
        set {
            if let newKey = newValue {
                UserDefaults.standard.set(newKey, forKey: "refresh_token")
            } else {
                UserDefaults.standard.removeObject(forKey: "refresh_token")
            }
        }
    }
    
    static var defaultTerm: String? {
        get {
            return UserDefaults.standard.string(forKey: "lastTerm")
        }
        set {
            if let newTerm = newValue {
                UserDefaults.standard.set(newTerm, forKey: "lastTerm")
            } else {
                UserDefaults.standard.removeObject(forKey: "lastTerm")
            }
        }
    }
    
    static func clear() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            UserDefaults.standard.synchronize()
        }
    }
}
