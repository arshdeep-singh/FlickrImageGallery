//
//  FlickrPhotoCollectionCell.swift
//  FlickrImageGalleryDemo
//
//  Created by Arshdeep Singh on 05/03/25.
//

import UIKit

class FlickrPhotoCollectionCell: UICollectionViewCell  {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    static let reuseIdentifier = "FlickrPhotoCollectionCell"
    static let nibName = "FlickrPhotoCollectionCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    private func setupCell() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    func configure(with photo: FlickrPhoto) {
        // Reset cell
        imageView.image = nil
        activityIndicator.startAnimating()
        
        // Load image
        guard let url = photo.imageURL else {
            activityIndicator.stopAnimating()
            return
        }
        
        ImageCacheManager.shared.loadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        activityIndicator.stopAnimating()
    }
}
