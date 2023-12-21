//
//  MainTabBarController.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 21.12.2023.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        
    }
    
    private func setupTabBar() {
        let imageListVC = ImagesListViewController()
        imageListVC.tabBarItem = .init(
            title: nil,
            image: UIImage(named: "noActiveTabbarBox"),
            selectedImage: UIImage(named: "activeTabbarBox")
        )
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = .init(
            title: nil,
            image: UIImage(named: "noActiveTabbarProfile"),
            selectedImage: UIImage(named: "activeTabbarProfile")
        )
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .ypBlack
        appearance.stackedLayoutAppearance.selected.iconColor = .ypWhite
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        viewControllers = [imageListVC, profileVC]
    }
}

//    private func setupTabBar() {
//        let imageListVC = ImagesListViewController()
//        let imageListNavVC = UINavigationController(rootViewController: imageListVC)
//        imageListNavVC.tabBarItem = .init(
//            title: nil,
//            image: UIImage(named: "noActiveTabbarBox"),
//            selectedImage: UIImage(named: "activeTabbarBox")
//        )
//
//        let profileVC = ProfileViewController()
//        let profileNavVC = UINavigationController(rootViewController: profileVC)
//        profileNavVC.tabBarItem = .init(
//            title: nil,
//            image: UIImage(named: "noActiveTabbarProfile"),
//            selectedImage: UIImage(named: "activeTabbarProfile")
//        )
//
//        let appearance = UITabBarAppearance()
//        appearance.backgroundColor = .ypBlack
//
//        tabBar.standardAppearance = appearance
//        viewControllers = (imageListNavVC, profileNavVC)
//    }
