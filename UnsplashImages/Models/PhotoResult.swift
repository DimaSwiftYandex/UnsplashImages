//
//  PhotoResult.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 23.2.2024.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
}
