//
//  AuthManager.swift
//  solorise
//
//  Created by Navid Sheikh on 12/06/2024.
//

import Foundation

class AuthManager {
    
    private static let userDefaults = UserDefaults.standard
    private static let userKey = "user"
    
    public static func clearUserDefaults() {
        removeUserDefaultsValue(forKey: userKey)
    }
    
    public static func setUserDefaults(user: User?) {
        if let user = user {
            if let encodedUser = try? JSONEncoder().encode(user) {
                setUserDefaultsValue(encodedUser, forKey: userKey)
            }
        }
    }
    
    private static func setUserDefaultsValue(_ value: Any?, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    private static func removeUserDefaultsValue(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    public static func getUser() -> User? {
        if let savedUserData = userDefaults.data(forKey: userKey),
           let savedUser = try? JSONDecoder().decode(User.self, from: savedUserData) {
            return savedUser
        }
        return nil
    }
}
