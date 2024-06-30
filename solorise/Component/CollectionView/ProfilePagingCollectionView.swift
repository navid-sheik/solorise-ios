//
//  PrrofilePagingCollectionView.swift
//  solorise
//
//  Created by Navid Sheikh on 22/06/2024.
//

//
//  OnBoardingCollectionView.swift
//  PersonifyMe
//
//  Created by Navid Sheikh on 30/07/2023.
//

import Foundation
import UIKit



struct PromoModel{
    var title : String
    var description: String
    var imageName : String
    
}

class ProfilePagingCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    //MARK: Properties
    
    var currentIndex = 0
    var timer: Timer?
    
    
    public let identifierBoarding = "OnBoardingLaunchViewController"
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

    
    let countries = [
        ("🇦🇺 Australia", "AU"),
        ("🇦🇹 Austria", "AT"),
        ("🇧🇪 Belgium", "BE"),
        ("🇧🇷 Brazil", "BR"),
        ("🇧🇬 Bulgaria", "BG"),
        ("🇨🇦 Canada", "CA"),
        ("🇨🇾 Cyprus", "CY"),
        ("🇨🇿 Czech Republic", "CZ"),
        ("🇩🇰 Denmark", "DK"),
        ("🇪🇪 Estonia", "EE"),
        ("🇫🇮 Finland", "FI"),
        ("🇫🇷 France", "FR"),
        ("🇩🇪 Germany", "DE"),
        ("🇬🇷 Greece", "GR"),
        ("🇭🇰 Hong Kong", "HK"),
        ("🇭🇺 Hungary", "HU"),
        ("🇮🇳 India", "IN"),
        ("🇮🇪 Ireland", "IE"),
        ("🇮🇹 Italy", "IT"),
        ("🇯🇵 Japan", "JP"),
        ("🇱🇻 Latvia", "LV"),
        ("🇱🇹 Lithuania", "LT"),
        ("🇱🇺 Luxembourg", "LU"),
        ("🇲🇹 Malta", "MT"),
        ("🇲🇽 Mexico", "MX"),
        ("🇳🇱 Netherlands", "NL"),
        ("🇳🇿 New Zealand", "NZ"),
        ("🇳🇴 Norway", "NO"),
        ("🇵🇱 Poland", "PL"),
        ("🇵🇹 Portugal", "PT"),
        ("🇷🇴 Romania", "RO"),
        ("🇸🇬 Singapore", "SG"),
        ("🇸🇰 Slovakia", "SK"),
        ("🇸🇮 Slovenia", "SI"),
        ("🇪🇸 Spain", "ES"),
        ("🇸🇪 Sweden", "SE"),
        ("🇨🇭 Switzerland", "CH"),
        ("🇹🇭 Thailand", "TH"),
        ("🇬🇧 United Kingdom", "GB"),
        ("🇺🇸 United States", "US")
    ]
    

 
    
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 0

        self.translatesAutoresizingMaskIntoConstraints = false
        self.isPagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.decelerationRate = .normal  // makes scrolling smoother
        self.dataSource = self
        self.delegate = self
        self.register(ProfilePagingCell.self, forCellWithReuseIdentifier: identifierBoarding)
       
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return promos.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        //User NOrmal cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierBoarding, for: indexPath) as! ProfilePagingCell
        cell.pageModel =  promos[indexPath.row]
        return cell
            
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width ,height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    @objc func autoScroll() {
            if self.currentIndex < self.promos.count {
                let indexPath = IndexPath(item: currentIndex, section: 0)
                self.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                self.currentIndex += 1
            } else {
                self.currentIndex = 0  // loop back to the first index
            }
    }
    

    
    
}


