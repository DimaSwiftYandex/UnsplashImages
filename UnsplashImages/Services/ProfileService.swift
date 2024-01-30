//
//  ProfileService.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 29.1.2024.
//

import UIKit

final class ProfileService {
    
    static let shared = ProfileService()
    
    private(set) var profile: Profile?
    private var task: URLSessionDataTask?
    private let urlSession = URLSession.shared
    private let api = APIManagerProfile()
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        guard let url = api.getURL() else { return }
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        task?.cancel()
        task = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(ProfileResult.self, from: data)
                let profile = Profile(from: result)
                DispatchQueue.main.async {
                    self.profile = profile
                    completion(.success(profile))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task?.resume()
    }
}
