//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 16.02.2025.
//
import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    // MARK: - Private variables
    private let oauth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    
    private lazy var logo : UIImageView = {
        let logo = UIImageView(image: UIImage(named: "vector"))
        return logo
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        setLogo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkAuthorization()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Private functions
    private func setLogo() {
        logo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logo)
        
        NSLayoutConstraint.activate([
            logo.heightAnchor.constraint(equalToConstant: 77.68),
            logo.widthAnchor.constraint(equalToConstant: 75),
            
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func checkAuthorization() {
        if let _ = oauth2TokenStorage.token {
            UIBlockingProgressHUD.show()
            self.fetchProfile {
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            }
            
        } else {
            showAuthScreen()
        }
    }
    
    private func showAuthScreen() {
        guard oauth2TokenStorage.token == nil else { return }
        
        let authScreen = AuthViewController()
        authScreen.delegate = self
        
        let navigationController = UINavigationController(rootViewController: authScreen)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: false)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("[ERROR] [SplashViewController/switchToTabBarController]: Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
           
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let token):
                self.fetchProfile {
                    UIBlockingProgressHUD.dismiss()
                }
            case .failure(let error):
                print("[ERROR] [SplashViewController/fetchOAuthToken]: Fetching auth token error: \(error)")
            }
        }
    }
    
    private func fetchProfile(completion: @escaping () -> Void) {
        guard let token = oauth2TokenStorage.token else {
            print("[ERROR] [SplashViewController/fetchProfile]: No token found")
            return
        }
        
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let profile):
                print("[INFO] User successfully fetched. Username: \(profile.loginName)")
                
                fetchProfileImage(for: profile.username)
                
                self.switchToTabBarController()
            case .failure(let error):
                print("[ERROR] [SplashViewController/fetchProfile]: Failed to fetch profile: \(error)")
            }
            completion()
        }
    }
    
    private func fetchProfileImage(for username: String) {
        profileImageService.fetchProfileImageURL(username: username)
    }
}
