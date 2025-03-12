import Foundation
import WebKit

final class ProfileLogoutService {
   static let shared = ProfileLogoutService()
    
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let imagesListService = ImagesListService.shared
  
   private init() { }

   func logout() {
      cleanCookies()
       
       oauth2TokenStorage.deleteToken()
       profileService.deleteProfile()
       profileImageService.deleteProfileImage()
       imagesListService.deletePhotos()
       
       print("[INFO] User has been logged out successfully")
   }

   private func cleanCookies() {
      HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
      WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
         records.forEach { record in
            WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
         }
      }
   }
}
    
