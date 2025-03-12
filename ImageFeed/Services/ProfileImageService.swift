//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 18.02.2025.
//
import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")

    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private(set) var imageURL: String?
    private var task: URLSessionTask?
    private var lastUsername: String?
    
    private init() {}
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastUsername != username else {
            print("Profile image request already in progress for the same username")
            completion(.failure(NetworkServiceError.invalidRequest))
            return
        }

        task?.cancel()
        lastUsername = username
        
        guard let request = makeProfileImageRequest(username: username) else {
            print("Failed to make profile image request")
            completion(.failure(NetworkServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                guard let self else { return }

                switch result {
                case .success(let response):
                    guard let image = response.profileImage.large else {
                        preconditionFailure("Failed to fetch profile image URL")
                    }
                    self.imageURL = image
                    completion(.success(image))
                    NotificationCenter.default
                        .post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": image]
                        )
                case .failure(let error):
                    print("Network request failed: \(error)")
                    completion(.failure(error))
                }
                
                self.task = nil
                self.lastUsername = nil
            }
        }
        
        self.task = task
        task.resume()
    }

    private func makeProfileImageRequest(username: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            print("Failed to create URL")
            return nil
        }

        guard let token = oauth2TokenStorage.token else {
            print("No auth token found")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
