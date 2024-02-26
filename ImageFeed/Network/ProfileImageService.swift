//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 26.02.2024.
//

import Foundation

struct UserResult: Codable {
    var profile_image: ImageURL?
}

struct ImageURL: Codable {
    var small: String?
}

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    private let urlSession = URLSession.shared
    private init () { }
    private (set) var avatarURL: String?
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    func fetchProfileImageURL(username: String, token: String, _ completion: @escaping (Result<String?, Error>) -> Void) {
        guard let request = createURLRequest(with: token, username: username) else { return }
        
        let task = object(for: request) { result in
            switch result {
            case .success(let body):
                self.avatarURL = body.profile_image?.small
                completion(.success(self.avatarURL))
                
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": self.avatarURL as Any])                    
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func createURLRequest(with token: String, username: String) -> URLRequest? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/users/\(username)"
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<UserResult, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<UserResult, Error> in
                Result {try decoder.decode(UserResult.self, from: data)}
            }
            print(response)
            completion(response)
        }
    }
}
