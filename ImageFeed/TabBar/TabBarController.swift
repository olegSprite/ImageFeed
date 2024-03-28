//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 02.03.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        let imagesListViewPresenter = ImageListViewPresenter()
        guard let imagesListViewController = imagesListViewController as? ImagesListViewController else { return }
        imagesListViewPresenter.view = imagesListViewController
        imagesListViewController.presenter = imagesListViewPresenter
        
        let profileViewController = ProfileViewController()
        let profileViewPresentor = ProfileViewPresenter()
        profileViewPresentor.view = profileViewController
        profileViewController.presenter = profileViewPresentor
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
    
}
