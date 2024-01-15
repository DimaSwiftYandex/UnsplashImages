//
//  SplashViewController.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 14.1.2024.
//

import UIKit

final class SplashViewController: UIViewController {

    //MARK: - Private properties
    private var launchViewController: LaunchViewController?
    private let oauth2Service = OAuth2Service()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLaunchViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.checkAuthentication()
        }
    }
    
    //MARK: - Private Functions
    private func setupLaunchViewController() {
        let launchVC = LaunchViewController()
        addChild(launchVC)
        view.addSubview(launchVC.view)
        launchVC.didMove(toParent: self)
        launchVC.view.frame = view.bounds
        launchViewController = launchVC
    }
    
    private func checkAuthentication() {
        if OAuth2TokenStorage.token != nil {
            switchToTabBarController()
        } else {
            presentAuthViewController()
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
}

//MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }

    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success (let token):
                OAuth2TokenStorage.token = token
                print("storage token ->", OAuth2TokenStorage.token)
                self.switchToTabBarController()
            case .failure (let error):
                print(error.localizedDescription)
            }
        }
    }
}
