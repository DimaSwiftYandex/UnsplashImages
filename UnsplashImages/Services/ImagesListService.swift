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
    private let api = APIManagerPhotos()
    private let token = OAuth2TokenStorage()
    
    private init() {}
    
    func fetchPhotosNextPage() {
        
        guard !isLoading else { return }
        isLoading = true
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let url = api.getURL(with: nextPage) else {
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
}
    
//    func fetchPhotosNextPage() {
//        
//        guard !isLoading else { return }
//        isLoading = true
//        
//        let nextPage = lastLoadedPage == nil
//        ? 1
//        : lastLoadedPage! + 1
//        
//        lastLoadedPage = nextPage
//        
//        guard let url = api.getURL(with: nextPage) else {
//            print("Invalid URL")
//            isLoading = false
//            return
//        }
//        var request = URLRequest(url: url)
//        request.addValue("Bearer \(token.token ?? "")", forHTTPHeaderField: "Authorization")
//        
//        task = urlSession.dataTask(with: request) { data, response, error in
//            if let error = error {
//                DispatchQueue.main.async {
//                    print(error.localizedDescription)
//                    self.isLoading = false
//                }
//                return
//            }
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    print("Bad Server Response")
//                    self.isLoading = false
//                }
//                return
//            }
//            do {
//                self.decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let photoResults = try self.decoder.decode([PhotoResult].self, from: data)
//                let photos = photoResults.map { Photo(from: $0) }
//                DispatchQueue.main.async {
//                    self.photos.append(contentsOf: photos)
//                    self.lastLoadedPage = nextPage
//                    
//                    NotificationCenter.default.post(
//                        name: ImagesListService.DidChangeNotification,
//                        object: nil
//                    )
//                    
//                    self.isLoading = false
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    print(error.localizedDescription)
//                    self.isLoading = false
//                }
//            }
//        }
//        task?.resume()
//    }


