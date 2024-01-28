//
//  OAuth2Service.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 14.1.2024.
//

import Foundation

final class OAuth2Service {
    
    private let urlSession = URLSession.shared
    private let apiToken = APIManagerToken()
    private var task: URLSessionDataTask?
    private var lastCode: String?

    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        guard let url = apiToken.getURL(code: code) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            self.task = nil
            if let error = error {
                self.lastCode = nil
                completion(.failure(error))
                return
            }
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  200...299 ~= response.statusCode else {
                self.lastCode = nil
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let tokenResponse = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(tokenResponse.accessToken))
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

