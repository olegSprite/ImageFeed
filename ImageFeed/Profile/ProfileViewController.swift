//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 18.01.2024.
//

import UIKit
import Kingfisher
import WebKit

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func updateAvatar(url: URL)
    func updateProfileDetails(profile: Profile)
    func cleanUserData()
}

final class ProfileViewController: UIViewController {
    
    private let profilePhotoImageView = UIImageView()
    private var nameLable = UILabel()
    private let nickNameLable = UILabel()
    private let statusLable = UILabel()
    private let exitButton = UIButton.systemButton(with: UIImage(imageLiteralResourceName: "Exit"), target: nil, action: nil)
    private var profileImageServiceObserver: NSObjectProtocol?
    var presenter: ProfileViewPresenterProtocol?
    
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        addObserver()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addObserver()
    }
    
    deinit {
        removeObserver()
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        addProfilePhotoImageView()
        addNameLable()
        addNickName()
        addStatus()
        addExitButton()
        presenter?.viewDidLoad()
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] notification in
                self?.updateAvatar(notification: notification)
            }
    }
    
    // MARK: - Funcs
    
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateAvatar(notification:)),
            name: ProfileImageService.didChangeNotification,
            object: nil)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: ProfileImageService.didChangeNotification,
            object: nil)
    }
    
    
    
    @objc
    private func updateAvatar(notification: Notification) {
        guard
            isViewLoaded,
            let userInfo = notification.userInfo,
            let profileImageURL = userInfo["URL"] as? String,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 35, backgroundColor: .clear)
        profilePhotoImageView.kf.indicatorType = .activity
        profilePhotoImageView.kf.setImage(with: url,
                                          placeholder: UIImage(systemName: "person.crop.circle.fill"),
                                          options: [.processor(processor),
                                                    .cacheSerializer(FormatIndicatedCacheSerializer.png)]) {result in
                                                        switch result {
                                                        case.success(let value):
                                                            print(value.image)
                                                            print(value.cacheType)
                                                            print(value.source)
                                                        case .failure(let error):
                                                            print(error)
                                                        }
                                                    }
        
    }
    
    
    
    
    private func addProfilePhotoImageView() {
        profilePhotoImageView.image = UIImage(systemName: "person.circle")
        profilePhotoImageView.layer.cornerRadius = 35
        profilePhotoImageView.clipsToBounds = true
        profilePhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profilePhotoImageView)
        profilePhotoImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profilePhotoImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profilePhotoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        profilePhotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
    }
    
    private func addNameLable() {
        nameLable.text = "Name Lastname"
        nameLable.textColor = .white
        nameLable.font = UIFont.boldSystemFont(ofSize: 23)
        nameLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLable)
        nameLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        nameLable.topAnchor.constraint(equalTo: profilePhotoImageView.bottomAnchor, constant: 8).isActive = true
    }
    
    private func addNickName() {
        nickNameLable.text = "@username"
        nickNameLable.textColor = .gray
        nickNameLable.font = nickNameLable.font.withSize(13)
        nickNameLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nickNameLable)
        nickNameLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        nickNameLable.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 8).isActive = true
    }
    
    private func addStatus() {
        statusLable.text = "Hello, world!"
        statusLable.textColor = .white
        statusLable.font = statusLable.font.withSize(13)
        statusLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLable)
        statusLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        statusLable.topAnchor.constraint(equalTo: nickNameLable.bottomAnchor, constant: 8).isActive = true
    }
    
    private func addExitButton() {
        exitButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        exitButton.accessibilityIdentifier = "logoutButton"
        exitButton.tintColor = UIColor(named: "YP Red")
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        exitButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        exitButton.centerYAnchor.constraint(equalTo: profilePhotoImageView.centerYAnchor).isActive = true
    }
    
    @objc private func didTapButton() {
        self.exitAlert()
    }
    
    private func exitAlert() {
        let alertController = UIAlertController(title: "Пока, пока!",
                                                message: "Уверены, что хотите выйти?",
                                                preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Нет",
                                   style: .cancel)
        let action = UIAlertAction(title: "Да", style: .default) { _ in
            self.presenter?.clearUserInfo()
        }
        alertController.addAction(action)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
}

extension ProfileViewController: ProfileViewControllerProtocol  {
    
    func cleanUserData() {
        self.nameLable.text = "Name"
        self.nickNameLable.text = "@name"
        self.statusLable.text = "bio"
        self.profilePhotoImageView.image = UIImage(named: "PhotoProfile")
    }
    
    func updateAvatar(url: URL) {
        profilePhotoImageView.kf.indicatorType = .activity
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        profilePhotoImageView.kf.setImage(with: url, options: [.processor(processor)])
    }
    
    func updateProfileDetails(profile: Profile) {
        self.nameLable.text = profile.name
        self.nickNameLable.text = profile.userName
        self.statusLable.text = profile.bio
    }
}
