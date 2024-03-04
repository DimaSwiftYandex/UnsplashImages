//
//  ProfilePresenter.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 3.3.2024.
//

import Foundation
import WebKit

protocol ProfilePresenterProtocol: AnyObject {
    var profileView: ProfileViewControllerProtocol? { get set }
    
    //View Event
    func viewWillAppear()
    func logoutButtonTapped()
    func logoutAlertYesButtonTapped()
    
    //Business Logic
    func performLogout()
    func fetchProfileAndUpdateUI()
}

class ProfilePresenter: ProfilePresenterProtocol {
    weak var profileView: ProfileViewControllerProtocol?
    
    //MARK: Services
    private let profileService = ProfileService.shared
    private let tokenStorage = OAuth2TokenStorage()
}

//MARK: - View Event
extension ProfilePresenter {
    
    func viewWillAppear() {
        fetchProfileAndUpdateUI()
    }
    
    func logoutButtonTapped() {
        profileView?.showLogoutAlert()
    }
    
    func logoutAlertYesButtonTapped() {
        performLogout()
    }
}

//MARK: - Business Logic
extension ProfilePresenter {
    
    //MARK: - UI Update Methods
    func fetchProfileAndUpdateUI() {
        guard let token = tokenStorage.token else { return }
        profileService.fetchProfile(token) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.profileView?.updateProfileDetails(with: profile)
                case .failure(let error):
                    print("Error fetching profile: \(error)")
                }
            }
        }
        profileView?.updateAvatar()
    }
    
    func performLogout() {
        clean()
        tokenStorage.token = nil
        profileView?.navigateToSplashVC()
        
        func clean() {
            HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
            WKWebsiteDataStore.default().fetchDataRecords(
                ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()
            ) { records in
                records.forEach { record in
                    WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                }
            }
        }
    }
}
