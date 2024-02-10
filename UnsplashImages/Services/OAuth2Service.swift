//
//  OAuth2Service.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 14.1.2024.
//

import Foundation

//final class OAuth2Service {
//    
//    private let urlSession = URLSession.shared
//    private let apiToken = APIManagerToken()
//    private var lastCode: String?
//
//    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
//        if lastCode == code { return }
//        lastCode = code
//        
//        guard let url = apiToken.getURL(code: code) else { return }
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        
//        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
//            switch result {
//            case .success(let tokenResponse):
//                self?.lastCode = nil
//                completion(.success(tokenResponse.accessToken))
//            case .failure(let error):
//                self?.lastCode = nil
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
//}

final class OAuth2Service {
    
    private let urlSession = URLSession.shared
    private let apiToken = APIManagerToken()
    private var lastCode: String?
    private var currentTask: URLSessionDataTask?
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        if lastCode == code { return }
        currentTask?.cancel()
        lastCode = code
        
        guard let url = apiToken.getURL(code: code) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        currentTask = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                self?.lastCode = nil
                self?.currentTask = nil
                
                switch result {
                case .success(let tokenResponse):
                    completion(.success(tokenResponse.accessToken))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        currentTask?.resume()
    }
}




