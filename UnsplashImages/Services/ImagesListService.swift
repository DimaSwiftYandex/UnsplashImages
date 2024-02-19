//
//  ImagesListService.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 15.2.2024.
//

import Foundation

final class ImagesListService {
    
    static let shared = ImagesListService()
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListProviderDidChange")
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionDataTask?
    private var isLoading: Bool = false
    
    private let urlSession = URLSession.shared
    private let decoder = JSONDecoder()
    private let apiPhotos = APIManagerPhotos()
    private let apiLikes = APIManagerLikes()
    private let token = OAuth2TokenStorage()
    
    private init() {}
    
    func fetchPhotosNextPage() {
        
        guard !isLoading else { return }
        isLoading = true
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let url = apiPhotos.getURL(with: nextPage) else {
            print("Invalid URL")
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token.token ?? "")", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let photoResults):
                let photos = photoResults.map { Photo(from: $0) }
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: photos)
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: nil)
                    self.isLoading = false
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.isLoading = false
            }
        }
        
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = apiLikes.getURL(photoId: photoId) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.addValue("Bearer \(token.token ?? "")", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
        task.resume()
    }
}



