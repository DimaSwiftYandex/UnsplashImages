//
//   ProfileImageService.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 30.1.2024.
//

import Foundation

final class ProfileImageService {
    
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    static let shared = ProfileImageService()
    
    private (set) var avatarURL: String?
    
    
    private var task: URLSessionDataTask?
    private let urlSession = URLSession.shared
    private let decoder = JSONDecoder()
    private let api = APIManagerProfile()
    private let token = OAuth2TokenStorage()
    
    private init() {}
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let url = api.getImageURL(username: username) else {
            DispatchQueue.main.async {
                completion(.failure(URLError(.badURL)))
            }
            return
        }
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token.token ?? "")", forHTTPHeaderField: "Authorization")
        
        task?.cancel()
        task = urlSession.objectTask(for: request) { (result: Result<UserResult, Error>) in
            switch result {
            case .success(let userResult):
                let imageURL = userResult.profileImage.small
                self.avatarURL = imageURL
                
                NotificationCenter.default.post(
                    name: ProfileImageService.DidChangeNotification,
                    object: self,
                    userInfo: ["URL": imageURL]
                )
                completion(.success(imageURL))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task?.resume()
    }
}
