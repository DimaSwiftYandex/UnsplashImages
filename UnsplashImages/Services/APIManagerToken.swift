//
//  APIManagerToken.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 27.1.2024.
//

import Foundation

final class APIManagerToken {
    
    func getURL(code: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "unsplash.com"
        urlComponents.path = "/oauth/token"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        return urlComponents.url
    }
}
