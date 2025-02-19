//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 19.02.2025.
//
import UIKit
 
final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
            
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
            
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
           title: "",
           image: UIImage(named: "Profile navigation (active)"),
           selectedImage: nil
       )
           
       self.viewControllers = [imagesListViewController, profileViewController]
   }
}
