//
//  MainTabBarController.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 14.1.2024.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    //MARK: - Private Properties
    private let imageListVC: ImagesListViewController = {
        let vc = ImagesListViewController()
        vc.tabBarItem = .init(
            title: nil,
            image: UIImage(named: "noActiveTabbarBox"),
            selectedImage: UIImage(named: "activeTabbarBox")
        )
        return vc
    }()
    
    private let profileVC: ProfileViewController = {
        let vc = ProfileViewController()
        vc.tabBarItem = .init(
            title: nil,
            image: UIImage(named: "noActiveTabbarProfile"),
            selectedImage: UIImage(named: "activeTabbarProfile")
        )
        return vc
    }()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    //MARK: - Private Functions (Tabbar)
    private func setupTabBar() {
        
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
