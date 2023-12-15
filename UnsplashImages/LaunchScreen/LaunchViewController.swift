//
//  LaunchViewController.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 12.12.2023.
//

import UIKit

class LaunchViewController: UIViewController {

    private var launchScreenImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Vector")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        setupView()
        setupConctraints()
    }
    
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
