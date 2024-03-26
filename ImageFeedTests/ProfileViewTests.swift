//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Олег Спиридонов on 23.03.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        _ = viewController.view
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
}

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    
    var viewDidLoadCalled: Bool = false
    var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func clearUserInfo() {
    }
}
    
