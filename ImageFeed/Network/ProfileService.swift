//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 23.02.2024.
//

import Foundation

struct ProfileResult: Codable {
    let userName: String
    let firstName: String
    let secondName: String
    let bio: String
}

struct Profile {
    let userName: String
    let name: String
    let loginName: String
    let bio: String
}

final class ProfileService {
    
    private func createURLRequest() -> URLRequest {
        
    }
}
