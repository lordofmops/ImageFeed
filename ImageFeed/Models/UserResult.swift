//
//  UserResult.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 18.02.2025.
//
import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
