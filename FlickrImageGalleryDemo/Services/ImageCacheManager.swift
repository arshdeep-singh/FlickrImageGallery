//
//  ImageCacheManager.swift
//  FlickrImageGalleryDemo
//
//  Created by Arshdeep Singh on 05/03/25.
//

import Foundation
import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private let cache = NSCache<NSString, UIImage>()
    private let imageProcessingQueue = DispatchQueue(label: "com.app.imageCacheQueue")
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        // Check cache first
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
            return
        }
        
        // Download image if not in cache
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard
                let self = self,
                let data = data,
                let image = UIImage(data: data),
                error == nil
            else {
                completion(nil)
                return
            }
            
            // Cache the image
            self.imageProcessingQueue.async {
                self.cache.setObject(image, forKey: url.absoluteString as NSString)
                
                // Ensure UI updates happen on main queue
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }.resume()
    }
}
