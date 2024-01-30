//
//  APIManagerProfile.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 29.1.2024.
//

import Foundation

final class APIManagerProfile {
    
    func getURL() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/me"
        
        return urlComponents.url
    }
}
