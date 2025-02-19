//
//  Photo.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 19.02.2025.
//
import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

extension Photo {
    init(from photoResult: PhotoResult) {
        self.id = photoResult.id
        self.size = CGSize(width: CGFloat(photoResult.width), height: CGFloat(photoResult.height))
        self.welcomeDescription = photoResult.description
        self.thumbImageURL = photoResult.urls.thumb
        self.largeImageURL = photoResult.urls.full
        self.isLiked = photoResult.likedByUser
        
        if let createdAt = photoResult.createdAt {
            self.createdAt = ISO8601DateFormatter().date(from: createdAt)
        } else {
            self.createdAt = nil
        }
    }
}
