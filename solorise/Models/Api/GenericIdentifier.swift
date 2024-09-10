//
//  GenericIdentifier.swift
//  solorise
//
//  Created by Navid Sheikh on 08/09/2024.
//

import Foundation
enum GenericIdentifier<T: Codable>: Codable {
    case string(String)
    case object(T)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // Try to decode as a String
        if let idString = try? container.decode(String.self) {
            self = .string(idString)
            return
        }
        
        // Try to decode as an object of type T
        if let object = try? container.decode(T.self) {
            self = .object(object)
            return
        }
        
        throw DecodingError.typeMismatch(GenericIdentifier.self,
                                         DecodingError.Context(codingPath: decoder.codingPath,
                                                               debugDescription: "Mismatched Types"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .string(let idString):
            try container.encode(idString)
        case .object(let object):
            try container.encode(object)
        }
    }
}
