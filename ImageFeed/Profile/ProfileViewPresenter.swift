//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 22.03.2024.
//

import Foundation
import WebKit

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func clearUserInfo()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    private let profileImageService = ProfileImageService.shared
    private let profileService = ProfileService.shared
    private var storage = OAuth2TokenStorage()
    weak var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        updateAvatar()
        updateProfileDetails()
    }
    
    func clearUserInfo() {
        cleanToken()
        cleanCookies()
        cleanUserData()
        goToSplashViewController()
    }
    
    private func updateAvatar() {
        if let urlString = profileImageService.avatarURL {
            if let url = URL(string: urlString) {
              view?.updateAvatar(url: url)
            }
        }
    }
    
    private func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        view?.updateProfileDetails(profile: profile)
    }
    
    private func cleanToken() {
        storage.removeToken()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func cleanUserData() {
        view?.cleanUserData()
        ImagesListService.shared.deletePhotos()
    }
    
    private func goToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else { preconditionFailure("Invalid Configuration") }
        window.rootViewController = SplashViewController()
    }
}
