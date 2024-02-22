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
    
    func clearToken() {
        
    }
}
