//
//  Example.swift
//  solorise
//
//  Created by Navid Sheikh on 26/05/2024.
//

import Foundation




struct   Example : Codable{
    let id : Int
    let exampleText  : String
}


extension Example{
    public func getMockArrray () -> [Example]{
        return [
            Example(id: 1 , exampleText: "Something"),
            Example(id: 1 , exampleText: "Something"),
            
            
        ]
    }
}
