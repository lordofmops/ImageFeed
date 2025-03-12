//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 16.02.2025.
//
import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    
    private init() {}
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            print("Failed to create URLComponents")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]
        
        guard let url = urlComponents.url else {
            print( "Failed to create URL")
            return nil
        }
        
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         return request
     }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastCode != code else {
            print("Auth request already in progress with the same code")
            completion(.failure(NetworkServiceError.invalidRequest))
            return
        }

        task?.cancel()                                      
        lastCode = code
        
        guard
            let request = makeOAuthTokenRequest(code: code)
        else {
            print("Failed to make auth token request")
            completion(.failure(NetworkServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                guard let self else { return }

                switch result {
                case .success(let response):
                    self.oauth2TokenStorage.token = response.accessToken
                    completion(.success(response.accessToken))
                case .failure(let error):
                    print("Network request failed: \(error)")
                    completion(.failure(error))
                }

                self.task = nil
                self.lastCode = nil
            }
        }

        self.task = task
        task.resume()
    }
}
