//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 04.03.2024.
//

import Foundation

final class ImagesListService {
    
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private (set) var photos: [Photo] = []
    private let urlSession = URLSession.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private lazy var iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    // MARK: - Photo
    
    func fetchPhotosNextPage() {
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard
            let request = createURLRequest(page: nextPage),
            task == nil
        else { return }
        assert(Thread.isMainThread)
        task = URLSession.shared.objectTask(for: request) { [weak self] (response: Result<[PhotoResult], Error>)  in
            guard let self = self else { return }
            switch response {
            case .success(let body):
                DispatchQueue.main.async {
                    var photos: [Photo] = []
                    body.forEach { photo in
                        photos.append(self.convertToPhoto(photo))
                    }
                    self.photos += photos
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                }
                self.task = nil
                self.lastLoadedPage = nextPage
            case .failure(let error):
                self.task = nil
                print("[ImagesListService]: \(error.localizedDescription) \(request)")
            }
        }
    }
    
    private func createURLRequest(page: Int) -> URLRequest? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/photos"
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
        ]
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = oauth2TokenStorage.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    private func convertToPhoto(_ photoResult: PhotoResult) -> Photo {
        let result = Photo(
            id: photoResult.id,
            size: CGSize(width: photoResult.width, height: photoResult.height),
            createdAt: self.iso8601Formatter.date(from: photoResult.created ?? ""),
            welcomeDescription: photoResult.description,
            thumbImageURL: photoResult.urls.small,
            largeImageURL: photoResult.urls.full,
            isLiked: photoResult.likedByUser)
        return result
    }
    
    func deletePhotos() {
        photos.removeAll()
    }
    
    // MARK: - Likes
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<ResultPhotoWhenLike, Error>) -> Void) {
        guard let request = createLikeURLRequest(id: photoId, isLike: isLike) else { return }
        task = URLSession.shared.objectTask(for: request) { [weak self] (response: Result<ResultPhotoWhenLike, Error>)  in
            guard let self = self else { return }
            switch response {
            case .success(let body):
                DispatchQueue.main.async {
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.largeImageURL,
                            isLiked: body.photo.likedByUser
                        )
                        self.photos[index] = newPhoto
                    }
                }
                completion(.success(body))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func createLikeURLRequest(id: String, isLike: Bool) -> URLRequest? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/photos/\(id)/like"
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        if isLike {
            request.httpMethod = "DELETE"
        } else { request.httpMethod = "POST" }
        if let token = oauth2TokenStorage.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
}
