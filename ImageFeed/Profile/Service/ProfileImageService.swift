//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 26.02.2024.
//

import Foundation



final class ProfileImageService {
    
    static let shared = ProfileImageService()
    private let urlSession = URLSession.shared
    private init () { }
    private (set) var avatarURL: String?
    private var task: URLSessionTask?
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    func fetchProfileImageURL(username: String, token: String, _ completion: @escaping (Result<String?, Error>) -> Void) {
        guard let request = createURLRequest(with: token, username: username) else { return }
        
        assert(Thread.isMainThread)
        
        if task != nil {
                task?.cancel()
            }
        
        task = URLSession.shared.objectTask(for: request) { [weak self] (response: Result<UserResult, Error>)  in
            
            self?.task = nil
            switch response {
            case .success(let body):
                self?.avatarURL = body.profile_image?.medium
                completion(.success(self?.avatarURL))
                
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": self?.avatarURL as Any])
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
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
}
