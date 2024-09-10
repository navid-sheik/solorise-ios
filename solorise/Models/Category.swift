//
//  Category.swift
//  solorise
//
//  Created by Navid Sheikh on 07/09/2024.
//

import Foundation

struct Category: Codable {
    let id: String           // Corresponding to _id: mongoose.Types.ObjectId
    let name: String
    let description: String
    let image: String?       // Optional field

    enum CodingKeys: String, CodingKey {
        case id = "_id"       // Mapping _id to id
        case name
        case description
        case image
    }
}


enum CategoryIdentifier: Codable {
    case string(String)
    case category(Category)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // Try to decode as a String
        if let idString = try? container.decode(String.self) {
            self = .string(idString)
            return
        }
        
        // Try to decode as a Category object
        if let categoryObject = try? container.decode(Category.self) {
            self = .category(categoryObject)
            return
        }
        
        throw DecodingError.typeMismatch(CategoryIdentifier.self,
                                         DecodingError.Context(codingPath: decoder.codingPath,
                                                               debugDescription: "Mismatched Types"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .string(let idString):
            try container.encode(idString)
        case .category(let categoryObject):
            try container.encode(categoryObject)
        }
    }
}
