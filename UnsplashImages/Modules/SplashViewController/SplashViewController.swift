//
//  SplashViewController.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 14.1.2024.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {

    private var launchViewController: LaunchViewController?
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
//    private let alertPresenter = AlertPresenter()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLaunchViewController()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIBlockingProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.checkAuthentication()
        }
    }

    private func setupLaunchViewController() {
        let launchVC = LaunchViewController()
        addChild(launchVC)
        view.addSubview(launchVC.view)
        launchVC.didMove(toParent: self)
        launchVC.view.frame = view.bounds
        launchViewController = launchVC
    }

    private func checkAuthentication() {
        
        if oauth2TokenStorage.token != nil {
            
            if let token = oauth2TokenStorage.token {
                print("token ->", token)
                self.fetchProfile(token: token) {
                    self.switchToTabBarController()
                    UIBlockingProgressHUD.dismiss()
                }
            }

           
        } else {
            presentAuthViewController()
            UIBlockingProgressHUD.dismiss()
        }
    }

    private func removeLaunchViewController() {
        launchViewController?.willMove(toParent: nil)
        launchViewController?.view.removeFromSuperview()
        launchViewController?.removeFromParent()
        launchViewController = nil
    }

    private func switchToTabBarController() {
        removeLaunchViewController()
        let tabBarController = MainTabBarController()
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        window.rootViewController = tabBarController
    }

    private func presentAuthViewController() {
        removeLaunchViewController()
        let authViewController = AuthViewController()
        authViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: authViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    // MARK: - Error Handling
    
    private func showErrorAlert() {
        let alertModel = AlertModel(title: "Something went wrong", message: "Failed to sign in")
        AlertPresenter.showAlert(from: self, with: alertModel)
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }

    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                print("token ->", token)
                oauth2TokenStorage.token = token
                print("storage token ->", oauth2TokenStorage.token)
                self.fetchProfile(token: token) {
                    UIBlockingProgressHUD.dismiss()
                }
                
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                self.showErrorAlert(with: error)
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchProfile(token: String, completion: @escaping ()->()) {
        
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profileImageService.fetchProfileImageURL(username: profile.username) { result in
                    switch result {
                    case .success(let profileImageURL):
                        completion()
                    case .failure(let error):
                        print(error)
                        UIBlockingProgressHUD.dismiss()
                        self.switchToTabBarController()
                    }
                }
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                self.showErrorAlert(with: error)
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Error Handling
    
    private func showErrorAlert(with error: Error) {
        let alertModel = AlertModel(title: "Something went wrong", message: error.localizedDescription)
        AlertPresenter.showAlert(from: self, with: alertModel)
    }
}
