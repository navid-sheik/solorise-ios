//
//  Journey .swift
//  solorise
//
//  Created by Navid Sheikh on 07/09/2024.
//

import Foundation

struct Journey: Codable {
    let id: String           // Corresponding to _id: Types.ObjectId
    let title: String
    let description: String
    let type: String         // e.g., "grind", "highlight", "journal"
    let category: CategoryIdentifier     // Corresponding to category: Types.ObjectId
    let thumbnail: String?   // Optional field
    let user: UserIdentifier         // Corresponding to user: Types.ObjectId
    let completed: Bool
    let visibility: String   // e.g., "public", "private"
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"           // Mapping _id to id
        case title
        case description
        case type
        case category
        case thumbnail
        case user
        case completed
        case visibility
    }
}


struct CreateJourneyRequest : Codable {
    let title: String
    let description: String
    let category: String
    let type: String
    let visibility: String
    
   
}

extension CreateJourneyRequest{
    func toDictionary() -> [String: Any] {
          return [
              "title": title,
              "description": description,
              "category": category,
              "type": type,
              "visibility": visibility
          ]
    }
    
}


struct UserJourneysGroupedByCategory : Codable{
    let id :String
    let journeys : [Journey]
    let categoryDetails : Category
    enum CodingKeys: String, CodingKey {
            case id = "_id"
            case journeys
            case categoryDetails
    }
}
