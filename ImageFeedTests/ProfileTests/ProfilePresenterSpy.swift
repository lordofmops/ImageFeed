import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?

    var viewDidLoadCalled = false
    var updateProfileImageCalled = false
    var didTapLogoutButtonCalled = false
    var updateProfileDataCalled = false
    var logoutHandlerCalled = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func updateProfileData(profile: Profile) {
        updateProfileDataCalled = true
    }

    func updateProfileImage(with url: String) {
        updateProfileImageCalled = true
    }

    func logoutHandler() {
        logoutHandlerCalled = true
    }

    func didTapLogoutButton() {
        didTapLogoutButtonCalled = true
    }
}
