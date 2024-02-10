//
//  OAuth2TokenStorage.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 14.1.2024.
//

import UIKit
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    private let tokenKey = "OAuthToken"
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            if let token = newValue {
                let isSuccess = KeychainWrapper.standard.set(token, forKey: tokenKey)
                if !isSuccess {
                    print("Error saving token in Keychain")
                }
            } else {
                let removeSuccessful = KeychainWrapper.standard.removeObject(forKey: tokenKey)
                if !removeSuccessful {
                    print("Error deleting token from Keychain")
                }
            }
        }
    }
}

//final class OAuth2TokenStorage {
//    
//    let userDefaults = UserDefaults.standard
//    private let tokenKey = "OAuthToken"
//    
//    var token: String? {
//        get {
//            UserDefaults.standard.string(forKey: tokenKey)
//        }
//        set {
//            if let token = newValue {
//                UserDefaults.standard.set(token, forKey: tokenKey)
//            } else {
//                UserDefaults.standard.removeObject(forKey: tokenKey)
//            }
//        }
//    }
//}
