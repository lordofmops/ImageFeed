import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
 
    var presenter: ProfilePresenterProtocol?

    var updateProfileDataCalled = false
    var updateProfileImageCalled = false
    var showLogoutAlertCalled = false
    var didTapExitButtonCalled = false

    func updateProfileData(profile: Profile) {
        updateProfileDataCalled = true
    }

    func updateProfileImage(url: URL) {
        updateProfileImageCalled = true
    }

    func didTapExitButton() {
        didTapExitButtonCalled = true
    }

    func showLogoutAlert() {
        showLogoutAlertCalled = true
    }
}
