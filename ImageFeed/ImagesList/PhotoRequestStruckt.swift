//
//  PhotoRequestStruckt.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 09.03.2024.
//

import Foundation

struct PhotoResult: Codable {
    var id: String
    var width: Int
    var height: Int
    var created: String?
    var description: String?
    var urls: UrlsResult
    var likedByUser: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case width = "width"
        case height = "height"
        case created = "created_at"
        case description = "description"
        case urls = "urls"
        case likedByUser = "liked_by_user"
    }
}

struct UrlsResult: Codable {
    var raw: String
    var full: String
    var regular: String
    var small: String
    var thumb: String
}

struct ResultPhotoWhenLike: Codable {
    let photo: PhotoResult
}
