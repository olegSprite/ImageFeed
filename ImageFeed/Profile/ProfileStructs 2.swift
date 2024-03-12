//
//  ProfileStructs.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 26.02.2024.
//

import Foundation

struct ProfileResult: Codable {
    var username: String
    var firstName: String
    var lastName: String?
    var bio: String?
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

struct Profile {
    let userName: String
    let name: String
    let bio: String
}

struct UserResult: Codable {
    var profile_image: ImageURL?
}

struct ImageURL: Codable {
    var small: String?
    var medium: String?
    var large: String?
}
