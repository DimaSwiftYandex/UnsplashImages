//
//  ProfileViewController.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 14.1.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    //MARK: - Private Properties
    private let profilePhoto = DefaultImage(style: .profilePhoto)
    private let logoutButton = DefaultButton(style: .logoutButtonStyle)
    private let profileNameLabel = DefaultLabel(style: .profileNameLabelStyle)
    private let userNameLabel = DefaultLabel(style: .userNameLabelStyle)
    private let descriptionLabel = DefaultLabel(style: .descriptionLabelStyle)
    
    private let flexibleSpace: UIView = {
        let flexibleSpace = UIView()
        flexibleSpace.setContentHuggingPriority(UILayoutPriority(rawValue: 1), for: .horizontal)
        return flexibleSpace
    }()
    
    private let photoAndButtonHorizontalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    private let labelsVerticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()

    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        setupViews(subviews: photoAndButtonHorizontalStack, labelsVerticalStack)
        setupHorizontalStackSubViews(subviews: profilePhoto, flexibleSpace, logoutButton)
        setupVerticalStackSubViews(subviews: profileNameLabel, userNameLabel, descriptionLabel)
        setupConstraints()
    }

}

//MARK: - Layout
extension ProfileViewController {
    private func setupViews(subviews: UIView...) {
        subviews.forEach { view.addSubview($0) }
    }
    
    private func setupHorizontalStackSubViews(subviews: UIView...) {
        subviews.forEach { subview in
            photoAndButtonHorizontalStack.addArrangedSubview(subview)
        }
    }
    
    private func setupVerticalStackSubViews(subviews: UIView...) {
        subviews.forEach { subview in
            labelsVerticalStack.addArrangedSubview(subview)
        }
    }
    
    private func setupConstraints() {
        photoAndButtonHorizontalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoAndButtonHorizontalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            photoAndButtonHorizontalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            photoAndButtonHorizontalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
        
        profilePhoto.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profilePhoto.widthAnchor.constraint(equalToConstant: 70),
            profilePhoto.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoutButton.widthAnchor.constraint(equalToConstant: 24),
            logoutButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        labelsVerticalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelsVerticalStack.topAnchor.constraint(equalTo: photoAndButtonHorizontalStack.bottomAnchor, constant: 8),
            labelsVerticalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            labelsVerticalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
}

