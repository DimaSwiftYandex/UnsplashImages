//
//  WebViewViewController.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 14.1.2024.
//

import UIKit
import WebKit

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol  {
    
    //MARK: - Public Properties
    var presenter: WebViewPresenterProtocol?
    weak var delegate: WebViewViewControllerDelegate?
    
    //MARK: - Private Properties
    private let webView = WKWebView()
    private let backButton = DefaultButton(style: .backButtonStyle)
    private let api = APIManagerAuthorize()
    private let progressView = ProgressView()
    private var estimatedProgressObservation: NSKeyValueObservation?

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(subViews: webView, backButton, progressView)
        setupConstraints()
        setupWebView()
        backButtonAction()
//        loadData()
//        observeWebViewProgress()
        
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
//        updateProgress()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            presenter?.didUpdateProgressValue(webView.estimatedProgress)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
//    private func observeWebViewProgress() {
//        estimatedProgressObservation = webView.observe(
//            \.estimatedProgress,
//            options: [.new]
//        ) { [weak self] _, _ in
//            self?.updateProgress()
//        }
//    }
    
//    private func updateProgress() {
//            progressView.progress = Float(webView.estimatedProgress)
//            progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
//        }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    private func setupWebView() {
        webView.backgroundColor = .ypWhite
        webView.navigationDelegate = self
    }
    
    private func backButtonAction() {
        backButton.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
//    private func loadData() {
//        guard let url = api.getURL() else { return }
//        let urlRequest = getURLRequest(url: url)
//        webView.load(urlRequest)
//    }
    
    private func getURLRequest(url: URL) -> URLRequest {
        let url = URLRequest(url: url)
        return url
    }
    
    //MARK: - Event Handler (Actions)
    @objc private func backButtonTapped() {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

//MARK: - Layout
extension WebViewViewController {
    
    private func setupView(subViews: UIView...) {
        subViews.forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 9),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9)
        ])
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 8),
            progressView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
}

//MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    } 

//    private func code(from navigationAction: WKNavigationAction) -> String? {
//        if
//            let url = navigationAction.request.url,
//            let urlComponents = URLComponents(string: url.absoluteString),
//            urlComponents.path == "/oauth/authorize/native",
//            let items = urlComponents.queryItems,
//            let codeItem = items.first(where: { $0.name == "code" })
//        {
//            return codeItem.value
//        } else {
//            return nil
//        }
//    }
}
