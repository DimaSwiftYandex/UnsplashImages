//
//  UnsplashImagesUITestsLaunchTests.swift
//  UnsplashImagesUITests
//
//  Created by Dmitry Dmitry on 3.3.2024.
//

import XCTest

final class UnsplashImagesUITestsLaunchTests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
        try super.setUpWithError()
        XCUIApplication().launch()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
}
