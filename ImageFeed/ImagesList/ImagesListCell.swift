//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 09.09.2024.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    var tableView: UITableView! { get }
}

final class ImagesListCell: UITableViewCell {
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet private weak var gradientImageView: UIImageView!
    
    static let reuseIdentifier = "ImagesListCell"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func configCell(with indexPath: IndexPath, from photos: [Photo]) {
        let photo = photos[indexPath.row]
        guard let url = URL(string: photo.regularImageURL) else { return }
        
        let placeholder = UIImage(named: "image_placeholder")
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: url, placeholder: placeholder) {[weak self] result in
            guard
                let self,
                let delegate = self.delegate
            else { return }
            
            delegate.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        if let createdAt = photo.createdAt {
            dateLabel.text = dateFormatter.string(from: createdAt)
        }
        
        let likeButtonImage = photo.isLiked
                                ? UIImage(named: "Like button (active)")
                                : UIImage(named: "Like button (inactive)")
        likeButton.setImage(likeButtonImage, for: .normal)
        likeButton.setTitle("", for: .normal)
        
        makeGradient()
    }
    
    private func makeGradient() {
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
