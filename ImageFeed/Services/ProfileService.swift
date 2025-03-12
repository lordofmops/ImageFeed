//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 18.02.2025.
//
import Foundation

final class ProfileService {
    static let shared = ProfileService()
    
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    private var lastToken: String?
    
    private init() {}
    
    func deleteProfile() {
        profile = nil
        task = nil
        lastToken = nil
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastToken != token else {
            print("Profile request already in progress with the same token")
            completion(.failure(NetworkServiceError.invalidRequest))
            return
        }

        task?.cancel()
        lastToken = token
        
        guard
            let request = makeProfileRequest(token: token)
        else {
            print("Failed to make profile request")
            completion(.failure(NetworkServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                guard let self else { return }
                
                switch result {
                case .success(let response):
                    let profile = Profile(from: response)
                    self.profile = profile
                    completion(.success(profile))
                case .failure(let error):
                    print("Network request failed: \(error)")
                    completion(.failure(error))
                }
                
                self.task = nil
                self.lastToken = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeProfileRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            print( "Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
     }
}
