//
//  ImagesListPresenter.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 29.2.2024.
//

import Foundation

protocol ImagesListPresenterProtocol: AnyObject {
    var imagesListview: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set}
    //View Event
    func viewDidLoad()
    func imageListCellDidTapLike(at indexPath: IndexPath)
    
    func updateTableViewAnimated()
    
    //Business Logic
    func fetchPhotosNextPage()
}

class ImagesListPresenter: ImagesListPresenterProtocol {
    
    
    
    var imagesListService = ImagesListService()
    weak var imagesListview: ImagesListViewControllerProtocol?
    
    var photos: [Photo] = []
    
    //MARK: View Event
    func viewDidLoad() {
        fetchPhotosNextPage()
    }
    
    //MARK: Business Logic
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            imagesListview?.performTableViewUpdates(oldCount: oldCount, newCount: newCount)
        }
    }
    
    func imageListCellDidTapLike(at indexPath: IndexPath) {
        guard indexPath.row < photos.count else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self?.photos[indexPath.row] = Photo(from: photo, isLiked: !photo.isLiked)
                    
                    self?.imagesListview?.performTableViewUpdates(indexPaths: [indexPath])
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

