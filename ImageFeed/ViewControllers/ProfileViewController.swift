//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 13.09.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet private weak var profileDescriptionLabel: UILabel!
    @IBOutlet private weak var nicknameLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var exitButton: UIButton!
    @IBOutlet private weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        exitButton.setTitle("", for: .normal)
    }
}
