//
//  OAuth2TokenStorage.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 14.1.2024.
//

import UIKit

final class OAuth2TokenStorage {
    static var token: String? {
        get {
            UserDefaults.standard.string(forKey: "OAuthToken")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "OAuthToken")
        }
    }
}
