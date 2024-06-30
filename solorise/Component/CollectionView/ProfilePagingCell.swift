//
//  ProfilePagingCell.swift
//  solorise
//
//  Created by Navid Sheikh on 22/06/2024.
//

import Foundation
import  UIKit


class ProfilePagingCell  : UICollectionViewCell {
    
    var pageModel : PromoModel? {
        didSet{
            if let pageTitle =  pageModel?.title{
                titleLabel.text =  pageTitle
            }
            if let pageDescription =  pageModel?.description{
                descriptionLabel.text =  pageDescription
            }
            if let pageImage =  pageModel?.imageName{
                imageView.image =  UIImage(named: pageImage)
            }
        }
    }
    
    
    
    
    let titleLabel  : UILabel = {
        let label  = UILabel()
        label.text = "Default for the title "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font =  UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    
    let descriptionLabel  : UILabel = {
        let label  = UILabel()
        label.text = "Default for the description"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font =  UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    let imageView:  UIImageView =  {
        let imageView  = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        setUpSubViews()
    }
    
    private func setUpSubViews(){
        
        

        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 45).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: self.frame.width - 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.widthAnchor.constraint(equalToConstant: self.frame.width - 20).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
