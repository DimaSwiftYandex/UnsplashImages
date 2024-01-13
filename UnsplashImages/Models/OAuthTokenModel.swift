//
//  OAuthTokenResponseBody.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 14.1.2024.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
