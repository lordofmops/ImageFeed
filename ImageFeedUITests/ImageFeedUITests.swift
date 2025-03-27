@testable import ImageFeed
import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
            
        XCTAssertTrue(webView.waitForExistence(timeout: 10))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
        loginTextField.tap()
        loginTextField.typeText("")
        app.toolbars.buttons["Done"].swipeDown()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10))
        passwordTextField.tap()
        passwordTextField.typeText("")
        app.toolbars.buttons["Done"].swipeDown()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: 5))
            
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        var cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        for i in 1...3 {
            cellToLike = tablesQuery.children(matching: .cell).element(boundBy: i)
            if cellToLike.isHittable && cellToLike.buttons["like button"].isHittable {
                return
            }
        }
        
        cellToLike.buttons["like button"].tap()
        sleep(3)
        cellToLike.buttons["like button"].tap()
        
        sleep(2)
        
        while !(cellToLike.isHittable) {
            cellToLike.swipeUp()
        }
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["back button white"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
       
        XCTAssertTrue(app.staticTexts["Name"].exists)
        XCTAssertTrue(app.staticTexts["@username"].exists)
        
        app.buttons["logout button"].tap()
        
        app.alerts["Пока-пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
