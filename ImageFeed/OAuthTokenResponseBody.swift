//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 05.02.2024.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let access_token: String
    let token_type: String
    let scope: String
    let created_at: Int
}
