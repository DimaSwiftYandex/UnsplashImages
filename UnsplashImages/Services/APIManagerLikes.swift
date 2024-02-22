//
//  APIManagerLikes.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 18.2.2024.
//

import Foundation

final class APIManagerLikes {
    
    func getURL(photoId: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/photos/\(photoId)/like"

        return urlComponents.url
    }
}
