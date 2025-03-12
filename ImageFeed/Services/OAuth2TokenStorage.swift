//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 16.02.2025.
//
import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private init() {}
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: "Auth token")
        }
        set {
            if let newValue {
                print(
                    KeychainWrapper.standard.set(newValue, forKey: "Auth token")
                    ? "Auth token successfully saved"
                    : "Failed to save auth token"
                )
            } else {
                print(
                    KeychainWrapper.standard.removeObject(forKey: "Auth token")
                    ? "Auth token successfully removed"
                    : "Failed to remove auth token"
                )
            }
        }
    }
    
    func deleteToken() {
        self.token = nil
    }
}
