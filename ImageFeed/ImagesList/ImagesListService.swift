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

    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func fetchPhotosNextPage() {
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let request = createURLRequest(page: nextPage) else { return }
        assert(Thread.isMainThread)
        if task != nil { return }
        
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
        print(url)
        return request
    }
    
    private func convertToPhoto(_ photoResult: PhotoResult) -> Photo {
        let dateFormatter = DateFormatter()
        let result = Photo(
            id: photoResult.id,
            size: CGSize(width: photoResult.width, height: photoResult.height),
            createdAt: dateFormatter.date(from: photoResult.created ?? ""), // - Проверить что дата норм форматируется
            welcomeDescription: photoResult.description,
            thumbImageURL: photoResult.urls.thumb,
            largeImageURL: photoResult.urls.full,
            isLiked: photoResult.likedByUser)
        return result
    }
}
