//
//  GrindCalendarCell.swift
//  solorise
//
//  Created by Navid Sheikh on 30/06/2024.
//

import Foundation
import UIKit


class GrindCalendarCell:  CustomCell{
    
    
    
    let mainImage : CustomImageView  = {
        let imageView  = CustomImageView()
        imageView.image =  UIImage(named: "image-placeholder")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor =  .init(white: 0.9, alpha: 0.5)
        return imageView
    }()
    
    override func setUpCell() {
        super.setUpCell()
        
        contentView.addSubview(mainImage)
        
        let width = self.frame.width
        mainImage.anchor( top: self.topAnchor, left: self.leadingAnchor, right: self.trailingAnchor, bottom :  nil, paddingTop: 0, paddingLeft: 0,paddingRight: 0, paddingBottom: 0, width: width, height: width)
    }
    
    
    
    
}
