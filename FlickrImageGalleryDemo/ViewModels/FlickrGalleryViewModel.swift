//
//  FlickrGalleryViewModel.swift
//  FlickrImageGalleryDemo
//
//  Created by Arshdeep Singh on 05/03/25.
//

import Foundation

class FlickrGalleryViewModel {
    private var photos: [FlickrPhoto] = []
    var isLoading = false
    
    var numberOfPhotos: Int {
        return photos.count
    }
    
    func fetchPhotos(completion: @escaping (Bool) -> Void) {
        guard !isLoading else { return }
        
        isLoading = true
        NetworkManager.shared.fetchPhotos { [weak self] result in
            guard let self = self else { return }
            
            defer { self.isLoading = false }
            
            switch result {
            case .success(let fetchedPhotos):
                let uniquePhotos = fetchedPhotos.filter { !self.photos.contains($0) }
                self.photos.append(contentsOf: uniquePhotos)
                completion(!uniquePhotos.isEmpty)
            case .failure(let error):
                print("Error fetching photos: \(error)")
                completion(false)
            }
        }
    }
    
    func photo(at index: Int) -> FlickrPhoto? {
        guard index < photos.count else { return nil }
        return photos[index]
    }
}
