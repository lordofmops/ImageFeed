//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 13.09.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    // MARK: - Private variables
    private var profile: Profile?
    private let profileService = ProfileService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var profileDescriptionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypWhite
        return label
    }()
    private lazy var nicknameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypGray
        return label
    }()
    private lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = .ypWhite
        return label
    }()
    private lazy var exitButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "exit_button"), for: .normal)
        button.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        button.tintColor = .ypRed
        return button
    }()
    private lazy var profilePicture : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_picture")
        imageView.tintColor = .gray
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        // UI setup
        view.backgroundColor = .ypBlack
        setProfilePicture()
        setExitButton()
        setNameLabel()
        setNicknameLabel()
        setProfileDescriptionLabel()
        
        // Fetching data
        if let profile = profileService.profile {
            self.profile = profile
            updateProfileData()
        }
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateImage()
            }
        updateImage()
    }
    
    // MARK: - Button action
    @objc
    private func didTapExitButton() {
        let alert = UIAlertController(
            title: "Пока-пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        
        let retryAction = UIAlertAction(title: "Да", style: .default){ [weak self] _ in
            guard let self else { return }
            self.profileLogoutService.logout()
            guard let window = UIApplication.shared.windows.first else {
                print("[ProfileViewController/didTapExitButton]: Unable to get window")
                return
            }
            window.rootViewController = SplashViewController()
            window.makeKeyAndVisible()
        }
        let cancelAction = UIAlertAction(title: "Нет", style: .default)
        
        alert.addAction(retryAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
    
    // MARK: - UI setup
    private func setProfilePicture(){
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profilePicture)
        
        NSLayoutConstraint.activate([
            profilePicture.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profilePicture.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            profilePicture.widthAnchor.constraint(equalToConstant: 70),
            profilePicture.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    private func setExitButton() {
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        
        NSLayoutConstraint.activate([
            exitButton.heightAnchor.constraint(equalToConstant: 24),
            exitButton.widthAnchor.constraint(equalToConstant: 24),
            
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            exitButton.centerYAnchor.constraint(equalTo: profilePicture.centerYAnchor)
        ])
    }
    
    private func setNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.heightAnchor.constraint(equalToConstant: 18),
            
            nameLabel.leadingAnchor.constraint(equalTo: profilePicture.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 8)
        ])
    }
    
    private func setNicknameLabel() {
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nicknameLabel)
        
        NSLayoutConstraint.activate([
            nicknameLabel.heightAnchor.constraint(equalToConstant: 18),
            
            nicknameLabel.leadingAnchor.constraint(equalTo: profilePicture.leadingAnchor),
            nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func setProfileDescriptionLabel() {
        profileDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileDescriptionLabel)
        
        NSLayoutConstraint.activate([
            profileDescriptionLabel.heightAnchor.constraint(equalToConstant: 18),
            
            profileDescriptionLabel.leadingAnchor.constraint(equalTo: profilePicture.leadingAnchor),
            profileDescriptionLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func updateProfileData() {
        guard let profile else { return }
        
        profileDescriptionLabel.text = profile.bio
        nicknameLabel.text = profile.loginName
        nameLabel.text = profile.name
    }
    
    private func updateImage() {
        guard
            let profileImageURL = ProfileImageService.shared.imageURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        let placeholder = UIImage(named: "profile_picture")
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        
        profilePicture.kf.indicatorType = .activity
        profilePicture.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .processor(processor)
            ]
        )
    }
}
