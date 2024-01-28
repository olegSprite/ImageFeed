//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 18.01.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let profilePhotoImageView = UIImageView()
    private let nameLable = UILabel()
    private let nickNameLable = UILabel()
    private let statusLable = UILabel()
    private let exitButton = UIButton.systemButton(
        with: UIImage(imageLiteralResourceName: "Exit"),
        target: ProfileViewController.self,
        action: #selector(Self.didTapButton)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        addProfilePhotoImageView()
        addNameLable()
        addNickName()
        addStatus()
        addExitButton()
    }
    
    private func addProfilePhotoImageView() {
        
        profilePhotoImageView.image = UIImage(named: "PhotoProfile")
        
        profilePhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profilePhotoImageView)
        
        profilePhotoImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profilePhotoImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profilePhotoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        profilePhotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
    }
    
    private func addNameLable() {
        
        nameLable.text = "Екатерина Новикова"
        nameLable.textColor = .white
        nameLable.font = UIFont.boldSystemFont(ofSize: 23)
        
        nameLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLable)
        
        nameLable.heightAnchor.constraint(equalToConstant: 18).isActive = true
        nameLable.widthAnchor.constraint(equalToConstant: 250).isActive = true
        nameLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        nameLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 110).isActive = true
    }
    
    private func addNickName() {
        nickNameLable.text = "@ekaterina_nov"
        nickNameLable.textColor = .gray
        nickNameLable.font = nickNameLable.font.withSize(13)
        
        nickNameLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nickNameLable)
        
        nickNameLable.heightAnchor.constraint(equalToConstant: 18).isActive = true
        nickNameLable.widthAnchor.constraint(equalToConstant: 250).isActive = true
        nickNameLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        nickNameLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 136).isActive = true
    }
    
    private func addStatus() {
        statusLable.text = "Hello, world!"
        statusLable.textColor = .white
        statusLable.font = statusLable.font.withSize(13)
        
        statusLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLable)
        
        statusLable.heightAnchor.constraint(equalToConstant: 18).isActive = true
        statusLable.widthAnchor.constraint(equalToConstant: 250).isActive = true
        statusLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        statusLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 162).isActive = true
    }
    
    private func addExitButton() {
        
        exitButton.tintColor = .red
        
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        
        exitButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55).isActive = true
    }
    
    @objc
    private func didTapButton() {
        
    }
}
