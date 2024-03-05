//
//  ProfileViewController.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 14.1.2024.
//

import UIKit
import Kingfisher
import WebKit

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    
    //Update View
    func updateProfileDetails(with profile: Profile)
    func updateAvatar()
    
    //Navigation
    func showLogoutAlert()
    func navigateToSplashVC()
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    var presenter: ProfilePresenterProtocol?
    
    //MARK: - Private Properties
    private var profileImageServiceObserver: NSObjectProtocol?
    
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
        print("ProfileViewController viewDidLoad called")
        view.backgroundColor = .ypBlack
        setupViewsAndConstraints()
        setupObservers()
        logoutButtonAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.viewWillAppear()
        //fetchProfileAndUpdateUI()
        DispatchQueue.main.async {
            self.updateAvatar()
        }
    }
    

    
    @objc private func logoutButtonTapped() {
        presenter?.logoutButtonTapped()
        
    }
    
    
    //MARK: - Setup Observers
    private func setupObservers() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAvatar()
        }
    }
    
    private func logoutButtonAction() {
        logoutButton.addTarget(
            self,
            action: #selector(logoutButtonTapped),
            for: .touchUpInside
        )
    }
}

//MARK: - Navigation
extension ProfileViewController {
    
    func navigateToSplashVC() {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                let splashViewController = SplashViewController()
                window.rootViewController = splashViewController
                window.makeKeyAndVisible()
            }
        }
    }
    
    func showLogoutAlert() {
        let alert = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to logout?",
            preferredStyle: .alert
        )
        
        alert.view.accessibilityIdentifier = "Bye bye!"
        
        let logoutAction = UIAlertAction(
            title: "Yes",
            style: .destructive
        ) { [weak self] _ in
            
            self?.presenter?.logoutAlertYesButtonTapped()
        }
        
        logoutAction.accessibilityIdentifier = "Yes"
        
        let cancelAction = UIAlertAction(
            title: "No",
            style: .cancel
        )
        
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

//MARK: - Update View {
extension ProfileViewController {
    func updateProfileDetails(with profile: Profile) {
        profileNameLabel.text = profile.name
        userNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    func updateAvatar() {
        
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL) else { return }
        
        print("->", url)
        
        let processor = RoundCornerImageProcessor(cornerRadius: profilePhoto.frame.height / 2)
        profilePhoto.kf.indicatorType = .activity
        
        profilePhoto.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]) { result in
                switch result {
                case .success(let value):
                    print(value.image)
                    print(value.cacheType)
                    print(value.source)
                case .failure(let error):
                    print(error)
                }
            }
    }
}

//MARK: - Layout
extension ProfileViewController {
    private func setupViewsAndConstraints() {
        [photoAndButtonHorizontalStack, labelsVerticalStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        [profilePhoto, flexibleSpace, logoutButton].forEach {
            photoAndButtonHorizontalStack.addArrangedSubview($0)
        }
        
        [profileNameLabel, userNameLabel, descriptionLabel].forEach {
            labelsVerticalStack.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            photoAndButtonHorizontalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            photoAndButtonHorizontalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            photoAndButtonHorizontalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            profilePhoto.widthAnchor.constraint(equalToConstant: 70),
            profilePhoto.heightAnchor.constraint(equalToConstant: 70),
            
            logoutButton.widthAnchor.constraint(equalToConstant: 24),
            logoutButton.heightAnchor.constraint(equalToConstant: 24),
            
            labelsVerticalStack.topAnchor.constraint(equalTo: photoAndButtonHorizontalStack.bottomAnchor, constant: 8),
            labelsVerticalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            labelsVerticalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
}
