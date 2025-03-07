//
//  FlickrPhoto.swift
//  FlickrImageGalleryDemo
//
//  Created by Arshdeep Singh on 05/03/25.
//

import Foundation


struct FlickrPhoto: Codable, Hashable {
    let title: String
    let link: String
    let media: Media
    
    var imageURL: URL? {
        return URL(string: media.m)
    }
}

struct Media: Codable, Hashable {
    let m: String
}

struct FlickrResponse: Codable {
    let items: [FlickrPhoto]
}
