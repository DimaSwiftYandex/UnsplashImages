//
//  UnsplashImagesUITests.swift
//  UnsplashImagesUITests
//
//  Created by Dmitry Dmitry on 3.3.2024.
//

import XCTest

final class UnsplashImagesUITests: XCTestCase {
    
    private let app = XCUIApplication()
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 7))
        
        //    let loginTextField = webView.descendants(matching: .textField).element
        //    XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        //
        //    loginTextField.tap()
        //    loginTextField.typeText("")
        //    webView.swipeUp()
        //
        //    let passwordTextField = webView.descendants(matching: .secureTextField).element
        //    XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        //
        //    passwordTextField.tap()
        //    passwordTextField.typeText("")
        //    webView.swipeUp()
        
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("insert yr password")
        //webView.swipeDown()
        
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("insert yr email")
        webView.swipeUp()
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["like button off"].tap()
        cellToLike.buttons["like button on"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        // Zoom in
        image.pinch(withScale: 3, velocity: 1) // zoom in
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["back button red"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Name Lastname"].exists)
        XCTAssertTrue(app.staticTexts["@username"].exists)
        
//        sleep(2)
        app.buttons["logout button"].tap()
        
//        sleep(2)
        app.alerts["Bye bye!"].scrollViews.otherElements.buttons["Yes"].tap()
    }

}
