//
//  User.swift
//  solorise
//
//  Created by Navid Sheikh on 11/06/2024.
//

import Foundation


struct User: Codable {
    let userId: String
    var name: String
    var email: String
    let password: String?
    var username: String
    var verified: Bool?
    var role: String?
    var verificationToken: String?
    var expireVerificationToken: String?
    var isActive: Bool
    var googleId: String?
    var profilePic: String?
    var deactivationReason: String?

    enum CodingKeys: String, CodingKey {
        case userId = "_id"
        case name
        case email
        case password
        case username
        case verified
        case role
        case verificationToken = "verification_token"
        case expireVerificationToken = "expire_verification_token"
        case isActive = "is_active"
        case googleId = "google_id"
        case profilePic = "profile_pic"
        case deactivationReason = "deactivation_reason"
    }
}


enum UserIdentifier: Codable {
    case string(String)
    case user(User)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // Debugging
        print("Debug container: \(container)")
        
        // Try to decode as a String
        if let idString = try? container.decode(String.self) {
            self = .string(idString)
            return
        }
        
        // Try to decode as a Seller object
        if let sellerObject = try? container.decode(User.self) {
            self = .user(sellerObject)
            return
        }
        
        // Debugging
        print("Failed to decode either as String or Seller object.")
        
        throw DecodingError.typeMismatch(UserIdentifier.self,
                                         DecodingError.Context(codingPath: decoder.codingPath,
                                                               debugDescription: "Mismatched Types"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .string(let idString):
            try container.encode(idString)
        case .user(let userObject):
            try container.encode(userObject)
        }
    }
}
