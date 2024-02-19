//
//  ImagesListViewController.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 14.1.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    //MARK: - Private Properties
    private var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared

    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .ypBlack
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        return tableView
    }()

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        setupViews()
        setupConstraints()
        setupNavigationBar()
        imagesListService.fetchPhotosNextPage()
        setupObservers()
    }
    
    //MARK: - Setup Observers
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateTableViewAnimated()
        }
    }
    
    //MARK: - Private Functions
    private func setupNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .ypBlack
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.tintColor = .ypWhite
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

//MARK: - Layout
extension ImagesListViewController {
    private func setupViews() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - UITabBarDelegate
extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let photo = photos[indexPath.row]
        showSingleImageScreen(photo: photo)
    }
}

//MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else { return UITableViewCell()}
        let photo = photos[indexPath.row]
        cell.configCell(with: photo, index: indexPath.row)
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: - Navigation
extension ImagesListViewController {
    private func showSingleImageScreen(photo: Photo) {
        let singleImage = SingleImageViewController()
        singleImage.photo = photo
        singleImage.modalPresentationStyle = .fullScreen
        present(singleImage, animated: true)
    }
}

//MARK: - Like Action
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            switch result {
            case .success():
                self?.photos[indexPath.row] = Photo(from: photo, isLiked: !photo.isLiked)
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
