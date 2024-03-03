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
    
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    // MARK: - viewDidAppear
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = OAuth2TokenStorage().token {
            fetchProfile(token)
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    // MARK: - prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)") }
            
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Func
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
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
            case .success:
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
            case .failure:
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
                    // TODO [Sprint 11] Покажите ошибку получения профиля
                    break
                }
            }
        }
}
