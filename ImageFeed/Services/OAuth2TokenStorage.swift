//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 16.02.2025.
//
import Foundation

final class OAuth2TokenStorage {
    var token: String? {
        get {
            storage.string(forKey: Keys.accessToken.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.accessToken.rawValue)
        }
    }
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case accessToken
    }
}
