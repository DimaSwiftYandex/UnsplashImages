//
//  SceneDelegate.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 11.12.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        window?.rootViewController = LaunchViewController()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.window?.rootViewController = ImagesListViewController()
        }
    }
}

