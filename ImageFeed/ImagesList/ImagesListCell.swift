//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 09.09.2024.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    weak var delegate: ImagesListCellDelegate?
    static let reuseIdentifier = "ImagesListCell"
    
    private lazy var likeButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "like_button_inactive"), for: .normal)
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var cellImage: UIImageView = {
        var imageView = UIImageView()
        
        contentView.backgroundColor = .ypBlack
        imageView.backgroundColor = .ypBlack
        
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypWhite
        return label
    }()
    
    private lazy var gradientImageView: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellImage()
        setupLikeButton()
        setupDateLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("[ERROR] [ImagesListCell/init]: init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func configCell(with indexPath: IndexPath, from photos: [Photo]) {
        let photo = photos[indexPath.row]
        guard let url = URL(string: photo.regularImageURL) else { return }
        
        let placeholder = UIImage(named: "photo_placeholder")
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(
            with: url,
            placeholder: placeholder)
        
        if let createdAt = photo.createdAt {
            dateLabel.text = Self.dateFormatter.string(from: createdAt)
        }
        
        let likeButtonImage = photo.isLiked
                                ? UIImage(named: "like_button_active")
                                : UIImage(named: "like_button_inactive")
        likeButton.setImage(likeButtonImage, for: .normal)
        
//        setupGradient()
    }
    
    func setLike(isLiked: Bool) {
        let likeButtonImage = isLiked
                                ? UIImage(named: "like_button_active")
                                : UIImage(named: "like_button_inactive")
        likeButton.setImage(likeButtonImage, for: .normal)
    }
    
    @objc
    private func didTapLikeButton() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    private func setupLikeButton() {
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            
            likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor)
        ])
    }
    
    private func setupCellImage() {
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellImage)
        
        NSLayoutConstraint.activate([
            cellImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupDateLabel() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: -8),
            
            dateLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
    
    private func setupGradient() {
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
        
        gradientImageView.translatesAutoresizingMaskIntoConstraints = false
        cellImage.addSubview(gradientImageView)
        
        NSLayoutConstraint.activate([
            gradientImageView.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor),
            gradientImageView.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            gradientImageView.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor),
            gradientImageView.topAnchor.constraint(equalTo: cellImage.topAnchor)
        ])
    }
}
