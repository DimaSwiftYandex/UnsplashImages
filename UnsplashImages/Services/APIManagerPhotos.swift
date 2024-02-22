//
//  APIManagerPhotos.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 16.2.2024.
//

import Foundation

final class APIManagerPhotos {
    
    func getURL(with nextPage: Int) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/photos"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(nextPage)"),
            URLQueryItem(name: "per_page", value: "10"),
            URLQueryItem(name: "order_by", value: "popular"),
        ]
        return urlComponents.url
    }
}
