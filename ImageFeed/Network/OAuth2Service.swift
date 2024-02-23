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
            
            if task != nil {
                if lastCode != code {
                    task?.cancel()
                } else {
                    completion(.failure(AuthServiceError.invalidRequest))
                    return
                }
            } else {
                if lastCode == code {
                    completion(.failure(AuthServiceError.invalidRequest))
                    return
                }
            }
            lastCode = code
            
            guard let request = authTokenRequest(code: code) else {
                        completion(.failure(AuthServiceError.invalidRequest))
                        return
                    }
            
            let task = object(for: request) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async{
                    switch result {
                    case .success(let body):
                        let authToken = body.accessToken
                        self.authToken = authToken
                        completion(.success(authToken))
                    case .failure(let error):
                        print(error)
                        completion(.failure(error))
                    }
                    self.task = nil                            // 14
                    self.lastCode = nil
                } }
            self.task = task
            task.resume()
        }
    
    private func authTokenRequest(code: String) -> URLRequest? {
        
        guard let urlCode_ = URL(string: "...\(code)") else {
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
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        print(request)
        return request
    }
    
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
            }
            completion(response)
        }
    }
    
    private struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
        }
    }
}
