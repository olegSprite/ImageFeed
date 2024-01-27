//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 18.01.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        addProfilePhotoImageView()
        addNameLable()
    }
    
    private func addProfilePhotoImageView() {
        
        let profilePhotoImageView = UIImageView()
        profilePhotoImageView.image = UIImage(named: "PhotoProfile")
        
        profilePhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profilePhotoImageView)
        
        profilePhotoImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profilePhotoImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profilePhotoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        profilePhotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
    }
    
    private func addNameLable() {
        let nameLable = UILabel()
        nameLable.text = "Екатерина Новикова"
        nameLable.textColor = .white
        
        nameLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLable)
        
        nameLable.heightAnchor.constraint(equalToConstant: 18).isActive = true
        nameLable.widthAnchor.constraint(equalToConstant: 250).isActive = true
        nameLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        nameLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 110).isActive = true
        
    }
}
