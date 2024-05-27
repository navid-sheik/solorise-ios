//
//  ApiErrorResponse.swift
//  solorise
//
//  Created by Navid Sheikh on 27/05/2024.
//

import Foundation

struct ApiErrorResponse : Codable{
    var status : String
    var message : String
    var code : Int


}
