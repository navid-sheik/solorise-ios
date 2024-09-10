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
    let journey : GenericIdentifier<Journey>?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case content
        case image
        case user
        case category
        case version = "__v"
        case journey
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


// Define a structure for posts grouped by their associated journey.
struct PostGroupedByJourney: Codable {
    let journeyId: String
    var posts: [Post]

    enum CodingKeys: String, CodingKey {
        case journeyId = "journeyId"
        case posts
    }
}
