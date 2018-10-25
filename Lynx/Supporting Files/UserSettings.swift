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
            return get(.accessKey) as? String
        }
        set {
            set(key: .accessKey, value: newValue)
        }
    }
    
    static var refreshKey: String? {
        get {
            return get(.refreshKey) as? String
        }
        set {
            set(key: .refreshKey, value: newValue)
        }
    }
    
    static var defaultTerm: String? {
        get {
            return get(.defaultTerm) as? String
        }
        set {
            set(key: .defaultTerm, value: newValue)
        }
    }
    
    static var userInformation: UserInformation? {
        get {
            guard let data = get(.userInformation) as? Data,
                let value = try? JSONDecoder().decode(UserInformation.self, from: data) else { return nil }
            return value
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            set(key: .userInformation, value: data)
        }
    }
    
    static func clear() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            UserDefaults.standard.synchronize()
        }
    }
}





extension UserSettings {
    private enum UserSettingKey: String {
        case accessKey = "access_tokey"
        case refreshKey = "refresh_token"
        case defaultTerm = "default_term"
        case userInformation = "user_info"
    }
    
    private static func set(key: UserSettingKey, value: Any?) {
        if let newValue = value {
            UserDefaults.standard.set(newValue, forKey: key.rawValue)
        } else {
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
    }
    
    private static func get(_ key: UserSettingKey) -> Any? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
}
