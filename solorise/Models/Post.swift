//
//  Post.swift
//  solorise
//
//  Created by Navid Sheikh on 30/06/2024.
//

import Foundation




struct Post: Codable {
    let id: String
    let content: String
    let image: String
    let user: String
    let version: Int?
    let category: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case content
        case image
        case user
        case category
        case version = "__v"
    }
}


struct Image: Codable {
    var caption: String
    var url: String
}

// Define a structure for the response that includes an array of images
struct ImagesResponse: Codable {
    var message : String
    var all_images: [Image]
}
