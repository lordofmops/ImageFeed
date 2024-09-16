//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 15.09.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage?  {
        didSet {
            guard let view else { return }
            imageView.image = image
        }
    }
    
    
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet private weak var exportButton: UIButton!
    @IBOutlet private weak var addToFavoritesButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBAction func didTapBackwardButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        imageView.image = image
        
        addToFavoritesButton.setTitle("", for: .normal)
        exportButton.setTitle("", for: .normal)
        backwardButton.setTitle("", for: .normal)
    }
}
