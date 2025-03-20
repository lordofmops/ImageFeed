import Foundation

public struct Profile {
    var username: String
    var name: String
    var loginName: String
    var bio: String?
}

extension Profile {
    init(from profileResult: ProfileResult) {
        self.username = profileResult.username
        self.name = [profileResult.firstName, profileResult.lastName].compactMap { $0 }.joined(separator: " ")
        self.loginName = "@\(profileResult.username)"
        self.bio = profileResult.bio
    }
}
