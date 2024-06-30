//
//  GrindCalendarViewControllerr.swift
//  solorise
//
//  Created by Navid Sheikh on 30/06/2024.
//

import Foundation

import UIKit

class GrindCalendarViewController :  UICollectionViewController {
    
    
    private let grindCalendarIdentifier: String =  "grindCalendarIdentifier"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor =  .systemBackground
        
        self.setUpCollectionView()
    }
    
    private func setUpCollectionView(){
        collectionView.register(GrindCalendarCell.self, forCellWithReuseIdentifier: grindCalendarIdentifier)
        collectionView.delegate = self
        
        
    
        
    }
    
    
    
}
extension GrindCalendarViewController : UICollectionViewDelegateFlowLayout{
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: grindCalendarIdentifier, for: indexPath) as! GrindCalendarCell
        
        
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collectionView.frame.width - 2) / 3 , height: self.collectionView.frame.width / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
}
