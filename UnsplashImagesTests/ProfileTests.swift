//
//  ProfileTests.swift
//  UnsplashImagesTests
//
//  Created by Dmitry Dmitry on 3.3.2024.
//

import Foundation
@testable import UnsplashImages
import XCTest

class ProfileViewControllerTests: XCTestCase {
    
    func testViewControllerCallsViewWillAppear() {
        // Given
        let viewController = ProfileViewController()
        let presenterSpy = ProfilePresenterSpy()
        
        viewController.presenter = presenterSpy
        
        // When
        viewController.viewWillAppear(true)
        
        // Then
        XCTAssertTrue(presenterSpy.viewWillAppearCalled, "viewWillAppear() should notify the presenter")
    }
}

class ProfilePresenterTests: XCTestCase {
    
    func testPresenterCallsPerformLogout() {
        // Given
        let presenterSpy = ProfilePresenterSpy()
        
        // When
        presenterSpy.logoutAlertYesButtonTapped()
        
        // Then
        XCTAssertTrue(presenterSpy.performLogoutCalled, "logoutAlertYesButtonTapped() should trigger performLogout")
    }
    
    func testPresenterFetchesProfileAndUpdateUI() {
        // Given
        let viewSpy = ProfileViewSpy()
        let presenterSpy = ProfilePresenterSpy()
        
        presenterSpy.profileView = viewSpy
        
        // When
        presenterSpy.viewWillAppear()
        
        // Then
        XCTAssertTrue(viewSpy.updateProfileDetailsCalled, "viewWillAppear() should fetch profile and update UI")
    }
    
    func testPresenterCallsUpdateAvatar() {
        // Given
        let viewSpy = ProfileViewSpy()
        let presenterSpy = ProfilePresenterSpy()
        
        presenterSpy.profileView = viewSpy
        
        // When
        presenterSpy.viewWillAppear()
        
        // Then
        XCTAssertTrue(viewSpy.updateAvatarCalled, "viewWillAppear() should trigger an avatar update")
    }
}

class ProfilePresenterSpy: ProfilePresenterProtocol {
    var profileView: ProfileViewControllerProtocol?
    
    var viewWillAppearCalled = false
    var logoutButtonTappedCalled = false
    var logoutAlertYesButtonTappedCalled = false
    var performLogoutCalled = false
    var fetchProfileAndUpdateUICalled = false

    func viewWillAppear() {
        viewWillAppearCalled = true
        fetchProfileAndUpdateUI()
    }
    
    func logoutButtonTapped() {
        logoutButtonTappedCalled = true
    }
    
    func logoutAlertYesButtonTapped() {
        logoutAlertYesButtonTappedCalled = true
        performLogout()
    }

    func performLogout() {
        performLogoutCalled = true
    }

    func fetchProfileAndUpdateUI() {
        fetchProfileAndUpdateUICalled = true
        
        let mockProfileResult = ProfileResult(username: "user", firstName: "User", lastName: "Name", bio: "Bio")
        
        let mockProfile = Profile(from: mockProfileResult)
        
        profileView?.updateProfileDetails(with: mockProfile)
        profileView?.updateAvatar()
    }

}

class ProfileViewSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    var updateProfileDetailsCalled = false
    var updateAvatarCalled = false
    var navigateToSplashVCCalled = false
    var showLogoutAlertCalled = false
    
    func updateProfileDetails(with profile: Profile) {
        updateProfileDetailsCalled = true
    }
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
    
    func navigateToSplashVC() {
        navigateToSplashVCCalled = true
    }
    
    func showLogoutAlert() {
        showLogoutAlertCalled = true
    }
}
