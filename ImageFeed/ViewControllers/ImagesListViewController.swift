//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 09.09.2024.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController, ImagesListCellDelegate {
    // MARK: - Private variables
    private let imagesListService = ImagesListService.shared
    private var photos: [Photo] = []
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imagesListServiceObserver: NSObjectProtocol?
    
    // MARK: - UI elements
    let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .ypBlack
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.separatorStyle = .none
        
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main,
                using: { [weak self] _ in
                    guard let self = self else { return }
                    self.updateTableViewAnimated()
                }
            )
        
        imagesListService.fetchPhotosNextPage()
    }
    
    // MARK: - Private functions
    private func setupTableView() {
        view.backgroundColor = .ypBlack
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath)
        
        guard let imagesListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imagesListCell.delegate = self
        imagesListCell.configCell(with: indexPath, from: photos)
        
        return imagesListCell
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        
        let singleImageScreen = SingleImageViewController()
        singleImageScreen.image = photo
        singleImageScreen.modalPresentationStyle = .fullScreen
        
        present(singleImageScreen, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        
        return (image.size.height * tableView.bounds.width) / image.size.width + 8
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath
    ) {
        guard indexPath.row + 1 == photos.count else { return }
        imagesListService.fetchPhotosNextPage()
    }
}
