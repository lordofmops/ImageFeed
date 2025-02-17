//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 17.02.2025.
//
import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
