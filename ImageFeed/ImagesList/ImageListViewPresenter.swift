//
//  ImageListViewPresenter.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 22.03.2024.
//

import Foundation

protocol ImageListViewPresenterProtocol: AnyObject {
    var view: ImageListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    func updateTable()
}

final class ImageListViewPresenter: ImageListViewPresenterProtocol {
    
    private var imageListService = ImagesListService.shared
    weak var view: ImageListViewControllerProtocol?
    var photos: [Photo] = []
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    func updateTable() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if oldCount != newCount {
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
}
