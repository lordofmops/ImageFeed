//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 09.09.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var gradientImageView: UIImageView!
    
    static let reuseIdentifier = "ImagesListCell"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    func configCell(with indexPath: IndexPath) {
        guard let cellImage = UIImage(named: "\(indexPath.row)") else {
            return
        }
        
        self.cellImage.image = cellImage
        
        dateLabel.text = dateFormatter.string(from: Date())
        
        let likeButtonImage = indexPath.row % 2 == 0
                                ? UIImage(named: "Like button (active)")
                                : UIImage(named: "Like button (inactive)")
        likeButton.setImage(likeButtonImage, for: .normal)
        likeButton.setTitle("", for: .normal)
        
        makeGradient()
    }
    
    func makeGradient() {
        gradientImageView.layer.masksToBounds = true
        gradientImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.ypBlack.withAlphaComponent(0.0).cgColor, UIColor.ypBlack.withAlphaComponent(1.0).cgColor]
        gradient.frame = gradientImageView.bounds
        gradient.opacity = 0.2
        
        gradientImageView.layer.sublayers?
                                .filter { $0 is CAGradientLayer }
                                .forEach { $0.removeFromSuperlayer() }
        gradientImageView.layer.addSublayer(gradient)
    }
}
