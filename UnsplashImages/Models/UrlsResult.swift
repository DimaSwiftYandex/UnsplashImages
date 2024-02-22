//
//  UrlsResult.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 23.2.2024.
//

import Foundation

struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
