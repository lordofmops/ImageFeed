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
    
    private var task: URLSessionTask?
    private var lastLoadedPage: Int?
    private(set) var photos: [Photo] = []
    
    private init() {}
    
    func fetchPhotosNextPage() {
        if let task {
            print("Images list request already in progress")
            task.cancel()
        }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = makeImagesListRequest(page: nextPage) else {
            print("Failed to make images list request")
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    let newPhotos = response.map { Photo(from: $0) }
                    self.photos.append(contentsOf: newPhotos)
                    
                    self.lastLoadedPage = nextPage
                    
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                case .failure(let error):
                    print("Network request failed: \(error)")
                }
                
                // Сбрасываем флаг загрузки
                self.isLoading = false
            }
        }
        // Сохраняем задачу
        self.task = task
        // Запускаем запрос
        task.resume()
    }
    
    private func makeImagesListRequest(page: Int) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/photos?page=\(page)") else {
            print("Failed to create URL")
            return nil
        }

//        guard let token = OAuth2TokenStorage().token else {
//            print("No auth token found")
//            return nil
//        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
