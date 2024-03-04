//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 08.02.2024.
//

import Foundation
import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    let showAuthenticationScreenSegueIdentifier = "AuthenticationScreenSegueIdentifier"
    
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private var logoImageView = UIImageView()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        addLogoImageView()
        view.backgroundColor = .ypBlack
    }
    
    // MARK: - viewDidAppear
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = OAuth2TokenStorage().token {
            fetchProfile(token)
        } else {
            guard let authViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else { return }
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true)
        }
    }
    
    // MARK: - Func
    
    private func addLogoImageView() {
        logoImageView.image = UIImage(named: "splash_screen_logo")
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func showErrorAlert() {
        let alertController = UIAlertController(title: "Что-то пошло не так(",
                                                message: "Не удалось войти в систему",
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok",
                                   style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

// MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                self.showErrorAlert()
                UIBlockingProgressHUD.dismiss()
                break
            }
        }
    }
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        guard let token = oauth2TokenStorage.token else {
            return
        }
        
        fetchProfile(token)
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                self.profileImageService.fetchProfileImageURL(username: user.userName, token: token) { _ in }
                self.switchToTabBarController()
                
            case .failure:
                break
            }
        }
    }
}
