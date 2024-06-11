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
