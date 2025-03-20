//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 20.02.2025.
//
import Foundation

struct PhotoResult: Codable {
    let id: String
    let width, height: Int
    let createdAt: String?
    let description: String?
    let urls: UrlsResult
    let likedByUser: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, width, height, description
        case createdAt = "created_at"
        case urls = "urls"
        case likedByUser = "liked_by_user"
    }
}
