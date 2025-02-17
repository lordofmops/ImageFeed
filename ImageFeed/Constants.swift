//
//  Constants.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 16.01.2025.
//

import Foundation

enum Constants {
    static let accessKey = "hoqRvUB9lpsXDoryE6JEUECulgM3k-hOFWTEP2yNSDY"
    static let secretKey = "UoiWVBL7qWgV_RpaT1j08-4Tu1PdixMuU77-faCidjk"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let defaultBaseURL: URL = URL(fileURLWithPath: "https://api.unsplash.com/")
    static let accessScope = "public+read_user+write_likes"
}
