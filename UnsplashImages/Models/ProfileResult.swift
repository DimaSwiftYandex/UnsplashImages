//
//  ProfileResult.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 23.2.2024.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?

    var name: String {
        return [firstName, lastName].compactMap { $0 }.joined(separator: " ")
    }
}
