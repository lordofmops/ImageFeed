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
    
    func deleteProfileImage() {
        imageURL = nil
        task = nil
        lastUsername = nil
    }
    
    func fetchProfileImageURL(username: String) {
        assert(Thread.isMainThread)
        guard lastUsername != username else {
            print("[ERROR] [ProfileImageService/fetchProfileImageURL]: Profile image request already in progress for the same username")
            return
        }

        task?.cancel()
        lastUsername = username
        
        guard let request = makeProfileImageRequest(username: username) else {
            print("[ERROR] [ProfileImageService/fetchProfileImageURL]: Failed to make profile image request")
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                guard let self else { return }

                switch result {
                case .success(let response):
                    guard let image = response.profileImage.large else {
                        print("[ERROR] [ProfileImageService/fetchProfileImageURL]: Failed to fetch profile image URL")
                        return
                    }
                    self.imageURL = image
                    print("[INFO] Profile image loaded")
                    
                    NotificationCenter.default
                        .post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": image]
                        )
                case .failure(let error):
                    print("[ERROR] [ProfileImageService/fetchProfileImageURL]: Network request failed: \(error)")
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
            print("[ERROR] [ProfileImageService/makeProfileImageRequest]: Failed to create URL")
            return nil
        }

        guard let token = oauth2TokenStorage.token else {
            print("[ERROR] [ProfileImageService/makeProfileImageRequest]: No auth token found")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
