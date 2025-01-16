//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 15.09.2024.
//

import UIKit

final class SingleImageViewController: UIViewController,
                                       UIScrollViewDelegate {
    var image: UIImage?  {
        didSet {
            guard isViewLoaded, let image else { return }
            imageView.image = image
            imageView.frame.size = image.size
            rescaleImage(image: image)
        }
    }
    
    // MARK: - Outlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var backwardButton: UIButton!
    @IBOutlet private weak var exportButton: UIButton!
    @IBOutlet private weak var addToFavoritesButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Actions
    @IBAction func didTapExportButton(_ sender: Any) {
        guard let image else { return }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction private func didTapLikeButton(_ sender: Any) {
    }
    
    @IBAction private func didTapBackwardButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image else { return }
        imageView.image = image
        imageView.frame.size = image.size
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        rescaleImage(image: image)
        
        addToFavoritesButton.setTitle("", for: .normal)
        exportButton.setTitle("", for: .normal)
        backwardButton.setTitle("", for: .normal)
        
    }
    
    // MARK: - Functions
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        let scrollViewSize = scrollView.bounds.size
        let imageSize = imageView.frame.size
        
        let x = max((scrollViewSize.width - imageSize.width) / 2, 0)
        let y = max((scrollViewSize.height - imageSize.height) / 2, 0)
        
        scrollView.contentInset = UIEdgeInsets(top: y, left: x, bottom: y, right: x)
    }
    
    // MARK: - Private functions
    private func rescaleImage(image: UIImage) {
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        
        let theoreticalScale = max(hScale, vScale)
        let scale = min(maxZoomScale, max(minZoomScale, theoreticalScale))
        
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}
