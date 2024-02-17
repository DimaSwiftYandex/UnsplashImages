//
//  ProfileViewController.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 14.1.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    //MARK: - Private Properties
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let profilePhoto = DefaultImage(style: .profilePhoto)
    private let logoutButton = DefaultButton(style: .logoutButtonStyle)
    private let profileNameLabel = DefaultLabel(style: .profileNameLabelStyle)
    private let userNameLabel = DefaultLabel(style: .userNameLabelStyle)
    private let descriptionLabel = DefaultLabel(style: .descriptionLabelStyle)
    private let profileService = ProfileService.shared
    private let tokenStorage = OAuth2TokenStorage()
    
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
        setupViews(subviews: photoAndButtonHorizontalStack, labelsVerticalStack)
        setupHorizontalStackSubViews(subviews: profilePhoto, flexibleSpace, logoutButton)
        setupVerticalStackSubViews(subviews: profileNameLabel, userNameLabel, descriptionLabel)
        setupConstraints()
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProfileAndUpdateUI()
        DispatchQueue.main.async {
            self.updateAvatar()
        }
    }
    
    //MARK: - Setup Observers
    private func setupObservers() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAvatar()
        }
    }
    
    //MARK: - UI Update Methods
    private func fetchProfileAndUpdateUI() {
        guard let token = tokenStorage.token else { return }
        profileService.fetchProfile(token) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.updateProfileDetails(with: profile)
                case .failure(let error):
                    print("Error fetching profile: \(error)")
                }
            }
        }
        updateAvatar()
    }
    
    private func updateAvatar() {
        
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
    
    private func updateProfileDetails(with profile: Profile) {
        profileNameLabel.text = profile.name
        userNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
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
