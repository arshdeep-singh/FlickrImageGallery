//
//  FlickrPhoto.swift
//  FlickrImageGalleryDemo
//
//  Created by Arshdeep Singh on 05/03/25.
//

import Foundation

struct FlickrPhoto: Codable, Hashable {
    let id: String
    let farm: Int
    let server: String
    let secret: String
    
    var imageURL: URL? {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")
    }
}

struct FlickrResponse: Codable {
    let photos: FlickrPhotoContainer
}

struct FlickrPhotoContainer: Codable {
    let photo: [FlickrPhoto]
}
