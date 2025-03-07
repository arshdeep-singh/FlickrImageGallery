//
//  NetworkManager.swift
//  FlickrImageGalleryDemo
//
//  Created by Arshdeep Singh on 05/03/25.
//

import Foundation



class NetworkManager {
    static let shared = NetworkManager()
    private let publicFeedURL = "https://www.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
    
    private init() {}
    
    func fetchPhotos(completion: @escaping (Result<[FlickrPhoto], Error>) -> Void) {
        guard let url = URL(string: publicFeedURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data Received", code: -2)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let flickrResponse = try decoder.decode(FlickrResponse.self, from: data)
                completion(.success(flickrResponse.items))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
