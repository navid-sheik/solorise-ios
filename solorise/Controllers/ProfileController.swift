//
//  ProfileController.swift
//  solorise
//
//  Created by Navid Sheikh on 15/06/2024.
//

import Foundation
import UIKit

class ProfileController : UIViewController{
    
    
    //MARK: PROPRETIES
    
    let promos = [
        PromoModel(title: "Smooth Payments", description: "Fast and easy payment process. Earn without hassle!", imageName: "onBoarding1"),
        PromoModel(title: "Simple KYC", description: "Quick, easy KYC steps. Your security matters.", imageName: "onBoarding1"),
        PromoModel(title: "Find Gift Seekers", description: "Reach a sea of buyers seeking unique gifts.", imageName: "onBoarding1"),
        PromoModel(title: "Manage Orders Easily", description: "User-friendly system to track and manage orders.", imageName: "onBoarding1"),
        PromoModel(title: "Effortless Listings", description: "Manage your items with our easy listing tool.", imageName: "onBoarding1"),
        PromoModel(title: "Swift Payouts", description: "Get your earnings fast, without the wait.", imageName: "onBoarding1"),
        PromoModel(title: "Low Fees", description: "Enjoy more earnings with our minimal fees.", imageName: "onBoarding1"),
        PromoModel(title: "Messaging System", description: "Connect with buyers easily within our platform.", imageName: "onBoarding1"),
        PromoModel(title: "Customized Focus", description: "Shine with your personalized items in our exclusive marketplace.", imageName: "onBoarding1")
    ]

    
    
    let mainImage : CustomImageView  = {
        let imageView  = CustomImageView()
        imageView.image =  UIImage(named: "image-placeholder")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius =  .init(10)
        
        imageView.clipsToBounds = true
        imageView.backgroundColor =  .init(white: 0.9, alpha: 0.5)
        return imageView
    }()
    
    let bio: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.masksToBounds = true
        textView.text = "Great things"
        textView.textAlignment = .justified
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.sizeToFit()
        textView.isScrollEnabled = true
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
   
        return textView
    }()
    
    let profileActivitiesCollection : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
       
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isScrollEnabled = true
        cv.backgroundColor = .systemBackground
//        cv.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        cv.showsHorizontalScrollIndicator =  false
    
        return cv
    }()
    
    
    
    
    let identifierCell : String  = "collecitonViewModIdentifier"
    let identifierCellPrrofileCollection : String =  "profileCollectionIdentifier"
    
    let onBoardCollectionView : ProfilePagingCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = ProfilePagingCollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    
    let scrollableCollectionView : UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
//        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .normal  // makes scrolling smoother
        
        return collectionView
        
        
    }()
    
    
    
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor =  .white
        self.edgesForExtendedLayout  = []
        self.view.backgroundColor =  .systemBackground
        
        self.navigationController?.navigationBar.isHidden = true
        self.setUpLayout()
        self.setupCollectionView()
    }
    
    //MARK: LAYOUT
    private func setUpLayout (){
        view.addSubview(mainImage)
        view.addSubview(bio)
        view.addSubview(profileActivitiesCollection)
        view.addSubview(scrollableCollectionView)
        
        mainImage.anchor( top: self.view.safeAreaLayoutGuide.topAnchor, left: self.view.leadingAnchor, right: nil, bottom: nil, paddingTop: 10, paddingLeft: 10,paddingRight: 0, paddingBottom: 0, width: nil, height: nil)
        mainImage.widthAnchor.constraint(equalToConstant: self.view.frame.width / 3).isActive = true
        mainImage.heightAnchor.constraint(equalToConstant: self.view.frame.width / 3).isActive = true
        
        
        bio.anchor( top: self.mainImage.bottomAnchor, left: self.view.leadingAnchor, right: self.view.trailingAnchor, bottom: nil, paddingTop: 10, paddingLeft: 10,paddingRight: -10, paddingBottom: 0, width: nil, height: 50)
    
        
        profileActivitiesCollection.anchor( top: self.bio.bottomAnchor, left: self.view.leadingAnchor, right: self.view.trailingAnchor, bottom: nil, paddingTop: 10, paddingLeft: 2,paddingRight: -2, paddingBottom: 0, width: nil, height: 30)
        
        
//        scrollableCollectionView.backgroundColor =  .blue
        scrollableCollectionView.anchor( top: self.profileActivitiesCollection.bottomAnchor, left: self.view.leadingAnchor, right: self.view.trailingAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, paddingTop: 10, paddingLeft: 2,paddingRight: -2, paddingBottom: 0, width: nil, height: nil)
        
//        profileActivitiesCollection.backgroundColor =  .blue
    }
    
    private func setupCollectionView() {
        profileActivitiesCollection.delegate = self
        profileActivitiesCollection.dataSource = self
        profileActivitiesCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: identifierCell)
        
        scrollableCollectionView.delegate = self
        scrollableCollectionView.dataSource = self
        scrollableCollectionView.register(ProfilePagingCell.self, forCellWithReuseIdentifier: identifierCellPrrofileCollection)
        
    }
    
    //MARK: ACTIONS
    
    
    
}

extension ProfileController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.scrollableCollectionView{
            return promos.count
        }
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView ==  self.scrollableCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierCellPrrofileCollection, for: indexPath) as! ProfilePagingCell
            cell.pageModel =  promos[indexPath.row]
            cell.backgroundColor  = .blue
            return cell
            
        }
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: identifierCell, for:  indexPath)
        cell.backgroundColor =  .brown
        let title = UILabel(frame: CGRect(x: 2, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.height))
       title.text = "Home"
       title.font = UIFont(name: "AvenirNext-Bold", size: 15)
       title.textAlignment = .left
       cell.contentView.addSubview(title)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if collectionView == profileActivitiesCollection{
            let size = CGSize(width: (collectionView.bounds.width - 4) / 5, height: collectionView.bounds.height)
            return size
        }
        
        let size = CGSize(width: (collectionView.bounds.width - 2), height: 200)
        return size
       
     }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    
}
