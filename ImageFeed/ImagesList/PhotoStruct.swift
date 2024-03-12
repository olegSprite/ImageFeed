//
//  PhotoStruct.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 04.03.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
