//
//  NetworkManager.swift
//  FlickrImageGalleryDemo
//
//  Created by Arshdeep Singh on 05/03/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let apiKey = "YOUR_FLICKR_API_KEY" // Replace with your actual Flickr API key
    private let baseURL = "https://api.flickr.com/services/rest/"
    
    private init() {}
    
    func fetchPhotos(page: Int = 1, completion: @escaping (Result<[FlickrPhoto], Error>) -> Void) {
        guard var urlComponents = URLComponents(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.getRecent"),
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "50")
        ]
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "URL Construction Failed", code: -2)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data Received", code: -3)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let flickrResponse = try decoder.decode(FlickrResponse.self, from: data)
                completion(.success(flickrResponse.photos.photo))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
