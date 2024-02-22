//
//  UserResult.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 30.1.2024.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImageSize
}

struct ProfileImageSize: Codable {
    let small: String
    let medium: String
    let large: String
}
