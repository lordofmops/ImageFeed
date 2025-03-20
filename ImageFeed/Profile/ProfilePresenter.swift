import Foundation
import UIKit

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func didTapLogoutButton()
    func updateProfileImage()
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
            view?.updateProfileData(profile: profile)
        }
        
        updateProfileImage()
    }
    
    func updateProfileImage() {
        guard let profileImageURL = imageService.imageURL,
              let url = URL(string: profileImageURL)
        else {
            print("[ERROR] [ProfilePresenter/updateProfileImage]: Unable to create URL")
            return
        }
        view?.updateProfileImage(url: url)
        print("[INFO] Profile image updated")
    }
    
    func didTapLogoutButton() {
        logoutService.logout()
        guard let window = UIApplication.shared.windows.first else {
            print("[ERROR] [ProfilePresenter/logoutHandler]: Unable to get window")
            return
        }
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
}

