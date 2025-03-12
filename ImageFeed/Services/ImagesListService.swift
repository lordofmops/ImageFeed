//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 19.02.2025.
//
import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private var task: URLSessionTask?
    private var lastLoadedPage: Int?
    private(set) var photos: [Photo] = []
    
    private var loadedPhotoIDs = Set<String>()
    
    private init() {}
    
    func deletePhotos() {
        photos.removeAll()
        task = nil
        lastLoadedPage = nil
        loadedPhotoIDs.removeAll()
    }
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        
        if task != nil {
            print("Images list request already in progress")
            return
        }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = makeImagesListRequest(page: nextPage) else {
            print("Failed to make images list request")
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                let newPhotos = response.map { Photo(from: $0) }
                    .filter{ !self.loadedPhotoIDs.contains($0.id) }
                
                self.photos.append(contentsOf: newPhotos)
                
                self.loadedPhotoIDs = Set<String>()
                self.loadedPhotoIDs.formUnion(newPhotos.map{ $0.id })
                
                self.lastLoadedPage = nextPage
                print("Page \(nextPage) loaded")
                
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self
                    )
            case .failure(let error):
                print("Network request failed: \(error)")
            }
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/photos/\(photoId)/like") else {
            print("Failed to create URL")
            return
        }

        guard let token = oauth2TokenStorage.token else {
            print("No auth token found")
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = isLike ? "POST" : "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            guard let self else { return }
            
            if let error {
                print("Failed to change like: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let indexPhoto = self.photos.firstIndex(where: {$0.id == photoId}) else {
                print("Failed to find photo in array")
                return
            }
            
            let photo = self.photos[indexPhoto]
            
            DispatchQueue.main.async {
                self.photos[indexPhoto] = Photo(
                    id: photo.id,
                    size: photo.size,
                    createdAt: photo.createdAt,
                    welcomeDescription: photo.welcomeDescription,
                    regularImageURL: photo.regularImageURL,
                    largeImageURL: photo.largeImageURL,
                    isLiked: !photo.isLiked
                )
                
                print("Like on photo \(photoId) changed on: \(self.photos[indexPhoto].isLiked)")
                
                completion(.success(()))
            }
        }
        task.resume()
    }
    
    private func makeImagesListRequest(page: Int) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/photos?page=\(page)") else {
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
