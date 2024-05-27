//
//  ApiResponse.swift
//  solorise
//
//  Created by Navid Sheikh on 27/05/2024.
//

import Foundation

struct ApiResponse<T: Codable>: Codable {
    var status : String
    var message : String
    var data : T?
}

