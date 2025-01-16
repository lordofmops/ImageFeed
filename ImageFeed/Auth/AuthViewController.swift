//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 16.01.2025.
//
import UIKit

final class AuthViewController: UIViewController {
    // MARK: - Private variables
    private lazy var authLogo : UIImageView = {
        let logo = UIImageView(image: UIImage(named: "Unsplash logo"))
        return logo
    }()
    
    private lazy var loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(UIColor(named: "YP Black"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = UIColor(named: "YP White")
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        setLoginButton()
        setAuthLogo()
    }
    
    // MARK: - Private functions
    private func setAuthLogo() {
        authLogo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(authLogo)
        
        NSLayoutConstraint.activate([
            authLogo.heightAnchor.constraint(equalToConstant: 60),
            authLogo.widthAnchor.constraint(equalToConstant: 60),
            
            authLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authLogo.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -300)
        ])
    }
    
    private func setLoginButton() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90)
        ])
    }
}
