//
//  OAuth2Service.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 14.1.2024.
//

import Foundation

final class OAuth2Service {
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "https://unsplash.com/oauth/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters: [String: String] = [
            "client_id": Constants.accessKey,
            "client_secret": Constants.secretKey,
            "redirect_uri": Constants.redirectURI,
            "code": code,
            "grant_type": "authorization_code"
        ]
        print("code ->", code)
        request.httpBody = parameters
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data,
                      let response = response as? HTTPURLResponse,
                      200...299 ~= response.statusCode else {
                    completion(.failure(URLError(.badServerResponse)))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let tokenResponse = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(tokenResponse.accessToken))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
