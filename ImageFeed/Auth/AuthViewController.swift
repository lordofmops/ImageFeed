//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 16.01.2025.
//
import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    weak var delegate: AuthViewControllerDelegate?
    
    private lazy var authLogo : UIImageView = {
        let logo = UIImageView(image: UIImage(named: "unsplash_logo"))
        return logo
    }()
    
    private lazy var loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.ypBlack, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .ypWhite
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(navigateToAuthScreen), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        setLoginButton()
        setAuthLogo()
        setBackwardButton()
    }
    
    // MARK: - Private functions
    @objc
    private func navigateToAuthScreen() {
        let authScreen = WebViewViewController()
        let authHelper = AuthHelper()
        let webViewPresenter = WebViewPresenter(authHelper: authHelper)
        authScreen.presenter = webViewPresenter
        webViewPresenter.view = authScreen
        authScreen.delegate = self
        
        navigationController?.pushViewController(authScreen, animated: true)
    }
    
    private func setAuthLogo() {
        authLogo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(authLogo)
        
        NSLayoutConstraint.activate([
            authLogo.heightAnchor.constraint(equalToConstant: 60),
            authLogo.widthAnchor.constraint(equalToConstant: 60),
            
            authLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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
    
    private func setBackwardButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back_button_black")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back_button_black")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .ypBlack
    }
    
    private func showAuthErrorAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(okAction)

        present(alert, animated: true)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        print("[INFO] User cancelled authentication")
        navigationController?.popViewController(animated: true)
    }
    
    func webViewViewController(_ vc: WebViewViewController, didFailWithError error: Error) {
        print("[ERROR] [AuthViewController/webViewViewController(didFailWithError:)]: Authentication failed: \(error.localizedDescription)")
        showAuthErrorAlert()
    }
}
