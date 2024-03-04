//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 23.02.2024.
//

import Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private (set) var profile: Profile?
    private var task: URLSessionTask?
    
    private func createURLRequest(with token: String) -> URLRequest? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/me"
        
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        guard let request = createURLRequest(with: token) else { return }
        
        assert(Thread.isMainThread)
        
        if task != nil {
            task?.cancel()
        }
        
        task = URLSession.shared.objectTask(for: request) { [weak self] (response: Result<ProfileResult, Error>)  in
            self?.task = nil
            guard let self = self else { return }
            switch response {
            case .success(let body):
                let profile = Profile(
                    userName: body.username ?? "Пусто",
                    name: "\(body.firstName ?? "Пусто") \(body.lastName ?? "Пусто")",
                    bio: body.bio ?? "Пусто"
                )
                self.profile = profile
                completion(.success((profile)))
            case .failure(let error):
                print("[ProfileService]: \(error.localizedDescription) \(request)")
                completion(.failure(error))
            }
        }
    }
}
