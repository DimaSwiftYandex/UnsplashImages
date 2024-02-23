//
//  ProfileModel.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 29.1.2024.
//

import Foundation

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(from result: ProfileResult) {
        self.username = result.username
        self.name = result.name
        self.loginName = "@\(result.username)"
        self.bio = result.bio
    }
}
