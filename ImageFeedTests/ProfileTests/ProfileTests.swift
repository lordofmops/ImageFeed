@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    func testPresenterCallsUpdateProfileImage() {
        // given
        let view = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        view.presenter = presenter
        presenter.view = view
        let url = "https://example.com"

        // when
        presenter.updateProfileImage(with: url)

        // then
        XCTAssertTrue(view.updateProfileImageCalled)
    }

    func testControllerCallsLogoutHandler() {
        // given
        let view = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        view.presenter = presenter
        presenter.view = view

        // when
        view.didTapExitButton()

        // then
        XCTAssertTrue(presenter.didTapLogoutButtonCalled)
    }

    func testPresenterCallsLogoutAlert() {
        // given
        let view = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        view.presenter = presenter
        presenter.view = view

        // when
        presenter.didTapLogoutButton()

        // then
        XCTAssertTrue(view.showLogoutAlertCalled)
    }

    func testPresenterHandlesProfileUpdate() {
        // given
        let view = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        view.presenter = presenter
        presenter.view = view

        let updatedProfile = Profile(
            username: "username",
            name: "name",
            loginName: "@username",
            bio: "bio"
        )

        // when
        presenter.updateProfileData(profile: updatedProfile)

        // then
        XCTAssertTrue(view.updateProfileDataCalled)
    }
}
