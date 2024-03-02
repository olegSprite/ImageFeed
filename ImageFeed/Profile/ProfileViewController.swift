//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 18.01.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let profilePhotoImageView = UIImageView()
    private var nameLable = UILabel()
    private let nickNameLable = UILabel()
    private let statusLable = UILabel()
    private let exitButton = UIButton.systemButton(
        with: UIImage(imageLiteralResourceName: "Exit"),
        target: ProfileViewController.self,
        action: #selector(Self.didTapButton)
    )
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // - Черновик
    
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
    
    private func addObserver() {
            NotificationCenter.default.addObserver(                 // 1
                self,                                               // 2
                selector: #selector(updateAvatar(notification:)),   // 3
                name: ProfileImageService.didChangeNotification,    // 4
                object: nil)                                        // 5
        }
    
    private func removeObserver() {
            NotificationCenter.default.removeObserver(              // 6
                self,                                               // 7
                name: ProfileImageService.didChangeNotification,    // 8
                object: nil)                                        // 9
        }
    
    @objc                                                       // 10
        private func updateAvatar(notification: Notification) {     // 11
            guard
                isViewLoaded,                                       // 12
                let userInfo = notification.userInfo,               // 13
                let profileImageURL = userInfo["URL"] as? String,   // 14
                let url = URL(string: profileImageURL)              // 15
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
            // TODO [Sprint 11] Обновите аватар, используя Kingfisher
        }
    
    private func updateAvatar(url: URL) {
        profilePhotoImageView.kf.indicatorType = .activity
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        profilePhotoImageView.kf.setImage(with: url, options: [.processor(processor)])
    }
    
    
    // - Черновик
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        addProfilePhotoImageView()
        addNameLable()
        addNickName()
        addStatus()
        addExitButton()
        
        guard let profile = profileService.profile else { return }
        updateProfileDetails(profile: profile)
        
        // - Черновик
        if let avatarURL = ProfileImageService.shared.avatarURL,// 16
                   let url = URL(string: avatarURL) {                   // 17
                    // TODO [Sprint 11]  Обновите аватар, если нотификация
                    // была опубликована до того, как мы подписались.
            
                }
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] notification in
                self?.updateAvatar(notification: notification)
            }
        
        // - Черновик
    }
    
    // MARK: - Funcs
    
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
        
        nameLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        nameLable.topAnchor.constraint(equalTo: profilePhotoImageView.bottomAnchor, constant: 8).isActive = true
    }
    
    private func addNickName() {
        nickNameLable.text = "@ekaterina_nov"
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
        
        exitButton.tintColor = UIColor(named: "YP Red")
        
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        
        exitButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        exitButton.centerYAnchor.constraint(equalTo: profilePhotoImageView.centerYAnchor).isActive = true
    }
    
    private func updateProfileDetails(profile: Profile) {
        
        self.nameLable.text = profile.name
        self.nickNameLable.text = profile.userName
        self.statusLable.text = profile.bio
    }
    
    @objc private func didTapButton() {
        
    }
}
