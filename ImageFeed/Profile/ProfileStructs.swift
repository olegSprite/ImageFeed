//
//  ProfileStructs.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 26.02.2024.
//

import Foundation

struct ProfileResult: Codable {
    var username: String?
    var first_name: String?
    var last_name: String?
    var bio: String?
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
}
