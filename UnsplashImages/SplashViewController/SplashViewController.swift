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
        switchToTabBarController()
    }
}
