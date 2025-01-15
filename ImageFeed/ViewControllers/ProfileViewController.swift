//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 13.09.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Private variables
    private var profileDescriptionLabel = UILabel()
    private var nicknameLabel = UILabel()
    private var nameLabel = UILabel()
    private var exitButton = UIButton()
    private var profilePicture = UIImageView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        setProfilePicture()
        setExitButton()
        setNameLabel()
        setNicknameLabel()
        setProfileDescriptionLabel()
    }
    
    // MARK: - Private functions
    private func setProfilePicture(){
        profilePicture.image = UIImage(named: "Profile picture")
        profilePicture.tintColor = .gray
        
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
        exitButton.setImage(UIImage(named: "Exit button"), for: .normal)
        exitButton.tintColor = UIColor(named: "YP Red")
        
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
        nameLabel.text = "Дарья"
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = UIColor(named: "YP White")
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.heightAnchor.constraint(equalToConstant: 18),
            
            nameLabel.leadingAnchor.constraint(equalTo: profilePicture.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 8)
        ])
    }
    
    private func setNicknameLabel() {
        nicknameLabel.text = "@lordofmopss"
        nicknameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        nicknameLabel.textColor = UIColor(named: "YP Gray")
        
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nicknameLabel)
        
        NSLayoutConstraint.activate([
            nicknameLabel.heightAnchor.constraint(equalToConstant: 18),
            
            nicknameLabel.leadingAnchor.constraint(equalTo: profilePicture.leadingAnchor),
            nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func setProfileDescriptionLabel() {
        profileDescriptionLabel.text = "description"
        profileDescriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        profileDescriptionLabel.textColor = UIColor(named: "YP White")
        
        profileDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileDescriptionLabel)
        
        NSLayoutConstraint.activate([
            profileDescriptionLabel.heightAnchor.constraint(equalToConstant: 18),
            
            profileDescriptionLabel.leadingAnchor.constraint(equalTo: profilePicture.leadingAnchor),
            profileDescriptionLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8)
        ])
    }
}
