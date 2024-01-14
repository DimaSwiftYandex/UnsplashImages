//
//  AuthViewController.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 14.1.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    
    //MARK: - Public Properties
    weak var delegate: AuthViewControllerDelegate?

    //MARK: - Private Properties
    private let unsplashImage = DefaultImage(style: .unsplashImage)
    private let firstLoginButton = DefaultButton(style: .firstLoginButtonStyle)

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        setupView(subViews: unsplashImage, firstLoginButton)
        setupConstraints()
        firstLoginButtonAction()
    }

    //MARK: - Private Functions
    private func firstLoginButtonAction() {
        firstLoginButton.addTarget(
            self,
            action: #selector(firstLoginButtonTapped),
            for: .touchUpInside
        )
    }
    
//    private func handleSuccessfulLogin(withToken token: String) {
//        OAuth2TokenStorage.token = token
//        delegate?.authViewController(self, didAuthenticateWithCode: token)
//    }
    
    private func handleSuccessfulLogin(withCode code: String) {
        let oauthService = OAuth2Service()
        oauthService.fetchAuthToken(code: code) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    print("token ->", token)
                    OAuth2TokenStorage.token = token
                    
                    print("storage token ->", OAuth2TokenStorage.token)
                    if let self = self {
                        self.delegate?.authViewController(self, didAuthenticateWithCode: token)
                    }
                case .failure(let error):
                    self?.showErrorAlert(message: "An error occurred during authentication: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }

    

    //MARK: - Event Handler (Actions)
    @objc private func firstLoginButtonTapped() {
        let webViewViewController = WebViewViewController()
        webViewViewController.modalPresentationStyle = .overFullScreen
        webViewViewController.delegate = self
        present(webViewViewController, animated: true)
    }
}

//MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
//        handleSuccessfulLogin(withToken: code)
        handleSuccessfulLogin(withCode: code)
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

//MARK: - Layout
extension AuthViewController {
    private func setupView(subViews: UIView...) {
        subViews.forEach { view.addSubview($0) }
    }

    private func setupConstraints() {
        unsplashImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            unsplashImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            unsplashImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        firstLoginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            firstLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            firstLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstLoginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -124),
            firstLoginButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
