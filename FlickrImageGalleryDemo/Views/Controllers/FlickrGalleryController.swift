//
//  FlickrGalleryController.swift
//  FlickrImageGalleryDemo
//
//  Created by Arshdeep Singh on 05/03/25.
//
import UIKit

class FlickrGalleryController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel = FlickrGalleryViewModel()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadInitialPhotos()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let nib = UINib(nibName: FlickrPhotoCollectionCell.nibName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: FlickrPhotoCollectionCell.reuseIdentifier)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = (view.frame.width - 20) / 3
            layout.itemSize = CGSize(width: width, height: width)
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 10
        }
        
        refreshControl.addTarget(self, action: #selector(refreshPhotos), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func loadInitialPhotos() {
        viewModel.fetchPhotos { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    @objc private func refreshPhotos() {
        viewModel.fetchPhotos { [weak self] success in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                if success {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension FlickrGalleryController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfPhotos
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlickrPhotoCollectionCell.reuseIdentifier, for: indexPath) as? FlickrPhotoCollectionCell,
              let photo = viewModel.photo(at: indexPath.item) else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: photo)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FlickrGalleryController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.numberOfPhotos - 5 && !viewModel.isLoading {
            viewModel.fetchPhotos { [weak self] success in
                DispatchQueue.main.async {
                    if success {
                        self?.collectionView.reloadData()
                    }
                }
            }
        }
    }
}
