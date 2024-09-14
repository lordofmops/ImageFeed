//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 13.09.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileDescriptionLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        exitButton.setTitle("", for: .normal)
    }
}
