//
//  ImageListViewTests.swift
//  ImageFeedTests
//
//  Created by Олег Спиридонов on 23.03.2024.
//

@testable import ImageFeed
import XCTest

final class ImageListViewTests: XCTestCase {
    
    func testViewControllerCallsfetchPhotos() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImageListViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        _ = viewController.view
        XCTAssertTrue(presenter.fetchPhotosCalled)
    }
    
}

final class ImageListViewPresenterSpy: ImageListViewPresenterProtocol {
    
    var photos: [Photo] = []
    
    var fetchPhotosCalled: Bool = false
    var view: ImageListViewControllerProtocol?
    
    func updateTable() {
    }
    
    func fetchPhotos() {
        fetchPhotosCalled = true
    }
}
