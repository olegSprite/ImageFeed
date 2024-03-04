//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 05.02.2024.
//

import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private init() {}
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        } }
    
    // MARK: - Func
    
    func fetchAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void) {
            assert(Thread.isMainThread)
            
            guard lastCode != code else { return }
            
            task?.cancel()
            lastCode = code
            
            guard let request = authTokenRequest(code: code) else { return }
            
            task = URLSession.shared.objectTask(for: request) { [weak self] (response: Result<OAuthTokenResponseBody, Error>)  in
                self?.task = nil
                switch response {
                case .success(let body):
                    let authToken = body.accessToken
                    self?.authToken = authToken
                    completion(.success(authToken))
                case .failure(let error):
                    print("[OAuth2Service]: \(error.localizedDescription) \(request)")
                    completion(.failure(error))
                }
            }
        }
    
    private func authTokenRequest(code: String) -> URLRequest? {
        
        guard URL(string: "...\(code)") != nil else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "unsplash.com"
        urlComponents.path = "/oauth/token"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "client_secret", value: secretKey),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        print(request)
        return request
    }
}
