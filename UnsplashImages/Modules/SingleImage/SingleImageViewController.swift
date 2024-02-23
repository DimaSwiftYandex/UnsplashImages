//
//  SingleImageViewController.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 14.1.2024.
//

import UIKit
import ProgressHUD

final class SingleImageViewController: UIViewController {
    
    //MARK: - Public Properties
    private(set) var photoUrl: URL?
    private(set) var photo: Photo?
    
    //MARK: - Private Properties
    private let singleImage = SingleImage()
    private let backwardButton = DefaultButton(style: .backwardButtonStyle)
    private let sharingButton = DefaultButton(style: .sharingButtonStyle)
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        return scrollView
    }()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        setupViewsAndConstraints()
        showImage()
        backwardButtonAction()
        sharingButtonAction()
    }
    
    //MARK: - Public Functions
    func setPhoto(_ newPhoto: Photo?) {
        self.photo = newPhoto
    }
    
    //MARK: - Private Functions
    private func showImage() {
        guard let photo = photo, let url = URL(string: photo.largeImageURL) else { return }
        UIBlockingProgressHUD.show()
        singleImage.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let value):
                self.rescaleAndCenterImageInScrollView()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func backwardButtonAction() {
        backwardButton.addTarget(
            self,
            action: #selector(backwardButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func sharingButtonAction() {
        sharingButton.addTarget(
            self,
            action: #selector(didTapShareButton),
            for: .touchUpInside
        )
    }
    
    private func rescaleAndCenterImageInScrollView() {
        guard let image = singleImage.image else { return }
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }

    private func showError() {
            let alert = UIAlertController(
                title: "Something went wrong",
                message: "Try again?",
                preferredStyle: .alert
            )

            let cancelAction = UIAlertAction(
                title: "No need",
                style: .cancel
            )

            let defaultAction = UIAlertAction(
                title: "Repeat",
                style: .default,
                handler: { [weak self] _ in
                    self?.showImage()
                }
            )

            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            present(alert, animated: true)
        }
    
    //MARK: - Event Handler (Actions)
    @objc private func backwardButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func didTapShareButton() {
        guard let image = singleImage.image else { return }

        let activityViewController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        self.present(activityViewController, animated: true)
    }
}

//MARK: - Layout
extension SingleImageViewController {
    private func setupViewsAndConstraints() {
        
        [scrollView, backwardButton, sharingButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        scrollView.addSubview(singleImage)
        singleImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            singleImage.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            singleImage.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            singleImage.topAnchor.constraint(equalTo: scrollView.topAnchor),
            singleImage.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            backwardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backwardButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            backwardButton.widthAnchor.constraint(equalToConstant: 24),
            backwardButton.heightAnchor.constraint(equalToConstant: 24),

            sharingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sharingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            sharingButton.widthAnchor.constraint(equalToConstant: 51),
            sharingButton.heightAnchor.constraint(equalToConstant: 51)
        ])
    }
}

//MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        singleImage
    }
}
