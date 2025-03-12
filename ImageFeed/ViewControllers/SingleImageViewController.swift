//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 15.09.2024.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    var image: Photo?
    {
        didSet {
            guard isViewLoaded, let image else { return }
            setImage()
            imageView.frame.size = image.size
        }
    }
    
    private let imagesListService = ImagesListService.shared
    
    // MARK: - Outlets
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        return scrollView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back_button_white"), for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var exportButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "export_button"), for: .normal)
        button.addTarget(self, action: #selector(didTapExportButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "favorites_button_inactive"), for: .normal)
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .ypBlack
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupImageView()
        setupBackButton()
        setupLikeButton()
        setupExportButton()
        setLike()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scrollView.delegate = self
        
        view.layoutIfNeeded()
        setImage()
    }

    // MARK: - Buttons actions
    @objc
    private func didTapExportButton(_ sender: Any) {
        guard let image else { return }
        let activityViewController = UIActivityViewController(activityItems: [image.largeImageURL], applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc
    private func didTapLikeButton(_ sender: Any) {
        guard let image else { return }
        let currentLike = !image.isLiked
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: image.id, isLike: currentLike) {[weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self.image = self.imagesListService.photos.filter { $0.id == image.id }.first
                    
                    self.setLike()
                    
                    UIBlockingProgressHUD.dismiss()
                    
                case .failure(let error):
                    print("[ERROR] [SingleImageViewController/didTapLikeButton]: Error changing like: \(error)")
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
        
        NotificationCenter.default.post(
            name: NSNotification.Name("LikeStatusChanged"),
            object: nil,
            userInfo: ["photoId": image.id, "isLiked": currentLike]
        )
    }
    
    @objc
    private func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private functions
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
        ])
    }
    
    private func setupExportButton() {
        exportButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exportButton)
        
        NSLayoutConstraint.activate([
            exportButton.widthAnchor.constraint(equalToConstant: 51),
            exportButton.heightAnchor.constraint(equalToConstant: 51),
            
            exportButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -68),
            exportButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    private func setupLikeButton() {
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            likeButton.widthAnchor.constraint(equalToConstant: 51),
            likeButton.heightAnchor.constraint(equalToConstant: 51),
            
            likeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 68),
            likeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    private func setupBackButton() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9)
        ])
    }
    
    private func setImage() {
        guard
            let image,
            let imageUrl = URL(string: image.largeImageURL)
        else { return }
        UIBlockingProgressHUD.show()
        
        imageView.kf.setImage(with: imageUrl) {[weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let result):
                self.rescaleImage(image: result.image)
            case .failure(let error):
                print("[ERROR] [SingleImageViewController/setImage]: Failed to set image: \(error)")
                self.showError()
            }
        }
        imageView.kf.indicatorType = .activity
    }
    
    private func setLike() {
        guard let image else { return }
        let buttonImage = image.isLiked
                            ? UIImage(named: "favorites_button_active")
                            : UIImage(named: "favorites_button_inactive")
        likeButton.setImage(buttonImage, for: .normal)
    }
    
    private func rescaleImage(image: UIImage) {
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        
        let minScale = min(hScale, vScale)

        scrollView.minimumZoomScale = min(minScale, scrollView.minimumZoomScale)
        scrollView.zoomScale = minScale

        scrollView.layoutIfNeeded()
        
        centerImage()
    }
    
    private func centerImage() {
        let scrollViewSize = scrollView.bounds.size
        let imageSize = imageView.frame.size

        let x = max((scrollViewSize.width - imageSize.width) / 2, 0)
        let y = max((scrollViewSize.height - imageSize.height) / 2, 0)

        scrollView.contentInset = UIEdgeInsets(top: y, left: x, bottom: y, right: x)
        
        UIBlockingProgressHUD.dismiss()
    }
    
    private func showError() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Что-то пошло не так. Попробовать ещё раз?",
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "Не надо", style: .default)
        let retryAction = UIAlertAction(title: "Повторить", style: .default){ [weak self] _ in
            guard let self else { return }
            self.setImage()
        }
        alert.addAction(cancelAction)
        alert.addAction(retryAction)

        present(alert, animated: true)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        centerImage()
    }
}
