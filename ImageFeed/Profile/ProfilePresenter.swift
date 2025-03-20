import Foundation
import UIKit

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func didTapLogoutButton()
    func logoutHandler()
    func updateProfileData(profile: Profile)
    func updateProfileImage(with url: String)
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    // MARK: - Private variables
    private let profileService = ProfileService.shared
    private let logoutService = ProfileLogoutService.shared
    private let imageService = ProfileImageService.shared
    
    // MARK: - ProfilePresenterProtocol
    func viewDidLoad() {
        if let profile = profileService.profile {
            updateProfileData(profile: profile)
        }
        
        if let profileImageURL = imageService.imageURL {
            updateProfileImage(with: profileImageURL)
        }
    }
    
    func updateProfileData(profile: Profile) {
        view?.updateProfileData(profile: profile)
    }
    
    func updateProfileImage(with url: String) {
        guard let url = URL(string: url)
        else {
            print("[ERROR] [ProfilePresenter/updateProfileImage]: Unable to create URL")
            return
        }
        view?.updateProfileImage(url: url)
    }
    
    func didTapLogoutButton() {
        view?.showLogoutAlert()
    }
             
    func logoutHandler() {
        logoutService.logout()
        guard let window = UIApplication.shared.windows.first else {
            print("[ERROR] [ProfilePresenter/logoutHandler]: Unable to get window")
            return
        }
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
}

