//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 23.02.2024.
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

final class ProfileService {
    
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    
    var profile: Profile?
    
    private func createURLRequest(with token: String) -> URLRequest? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/me"
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void) {
        
        guard let request = createURLRequest(with: token) else { return }
        
            let task = object(for: request) { [weak self] result in
            guard let self = self else { return }
    
            switch result {
            case .success(let body):
                self.profile = Profile(userName: body.username ?? "Пусто", name: "\(body.first_name ?? "Пусто") \(body.last_name ?? "Пусто")", bio: body.bio ?? "Пусто")
                completion(.success(self.profile!))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            } }
        task.resume()
    }
    
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<ProfileResult, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<ProfileResult, Error> in
                Result {try decoder.decode(ProfileResult.self, from: data)}
            }
            print(response)
            completion(response)
        }
    }
}
