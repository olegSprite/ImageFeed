//
//  URLSessionExtention.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 28.02.2024.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case decodingErorr
}

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletion: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(T.self, from: data)
                        fulfillCompletion(.success(result))
                    }
                    catch {
                        print("Ошибка декодирования: \(error.localizedDescription), Данные: \(String(data: data, encoding: .utf8) ?? "")")
                        fulfillCompletion(.failure(NetworkError.decodingErorr))
                    }
                } else {
                    print("[objectTask(for:)]: \(String(describing: error?.localizedDescription))")
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("[objectTask]: \(error)")
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("[objectTask(for:)]: \(String(describing: error?.localizedDescription))")
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    }
}
