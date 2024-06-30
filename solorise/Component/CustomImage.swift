//
//  CustomImage.swift
//  solorise
//
//  Created by Navid Sheikh on 16/06/2024.
//

import Foundation
import UIKit


let imageCache  =  NSCache<NSString, UIImage>()
class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    
    func loadImageUrlString( urlString: String){
        imageUrlString =  urlString
        guard let url = URL(string: urlString) else {return}
        image = nil
        
        if let imageFromCache  =  imageCache.object(forKey: urlString as NSString){
            self.image =  imageFromCache
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let imageToCache   = UIImage(data: data)
                if self.imageUrlString == urlString{
                    self.image =  imageToCache
                }
                imageCache.setObject(imageToCache!, forKey: urlString as NSString)
            }
            
        }.resume()
    }
    
    
    
}
