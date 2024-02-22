//
//  LaunchViewController.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 14.1.2024.
//

import UIKit

final class LaunchViewController: UIViewController {

    //MARK: - Private Properties
    private var launchScreenImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Vector")
        return imageView
    }()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        setupView()
        setupConctraints()
    }
}

//MARK: - Layout
extension LaunchViewController {
    private func setupView() {
        view.addSubview(launchScreenImageView)
    }
    
    private func setupConctraints() {
        launchScreenImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            launchScreenImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            launchScreenImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            launchScreenImageView.widthAnchor.constraint(equalToConstant: 75),
            launchScreenImageView.heightAnchor.constraint(equalToConstant: 77.68)
        ])
    }
}
