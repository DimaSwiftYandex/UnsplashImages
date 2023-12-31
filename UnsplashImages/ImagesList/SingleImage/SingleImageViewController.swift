//
//  SingleImageViewController.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 22.12.2023.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    //MARK: - Public Properties
    var singleImageName: String? {
        didSet {
            guard let singleImageName = singleImageName, 
                  let image = UIImage(named: singleImageName)
                  else { return }
            singleImage.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
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
        setupScrollView()
        setupViews(subViews: scrollView, backwardButton, sharingButton)
        setupConstraints()
        showImage()
        backwardButtonAction()
        sharingButtonAction()
    }
    
    //MARK: - Private Functions
    private func showImage() {
        guard let singleImageName = singleImageName,
              let image = UIImage(named: singleImageName)
              else { return }
        singleImage.image = image
        rescaleAndCenterImageInScrollView(image: image)
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
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
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
}

//MARK: - Layout
extension SingleImageViewController {
    private func setupViews(subViews: UIView...) {
        subViews.forEach { subView in
            view.addSubview(subView)
        }
    }
    
    private func setupScrollView() {
        scrollView.addSubview(singleImage)
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        singleImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            singleImage.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            singleImage.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            singleImage.topAnchor.constraint(equalTo: scrollView.topAnchor),
            singleImage.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            singleImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            singleImage.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        backwardButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backwardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backwardButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            backwardButton.widthAnchor.constraint(equalToConstant: 24),
            backwardButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        sharingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
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


