//
//  Untitled.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 18.02.2025.
//
import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username, bio
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
