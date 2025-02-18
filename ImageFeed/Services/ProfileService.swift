//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 18.02.2025.
//
import Foundation

enum ProfileServiceError: Error {
    case invalidRequest
}

final class ProfileService {
    static let shared = ProfileService()
    var profile: Profile?
    
    private var task: URLSessionTask?
    private var lastToken: String?
    
    private init() {}
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastToken != token else {
            print("Profile request already in progress with the same token")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }

        task?.cancel()
        lastToken = token
        
        guard
            let request = makeProfileRequest(token: token)
        else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.data(for: request) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(ProfileResult.self, from: data)
                        let profile = Profile(
                            username: response.username,
                            name: [response.firstName, response.lastName].compactMap { $0 }.joined(separator: " "),
                            loginName: "@\(response.username)",
                            bio: response.bio
                        )
                        completion(.success(profile))
                    } catch {
                        print("Failed to decode ProfileResult: \(error)")
                        completion(.failure(error))
                    }
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
    
    func makeProfileRequest(token: String) -> URLRequest? {
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
