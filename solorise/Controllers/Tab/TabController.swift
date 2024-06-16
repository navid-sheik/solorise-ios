//
//  TabController.swift
//  solorise
//
//  Created by Navid Sheikh on 15/06/2024.
//

import Foundation
import UIKit

class TabController :  UITabBarController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpStyle()
        self.setUpTabs()
    }
    
    //MARK: STYLE
    
    private func setUpStyle(){
        self.edgesForExtendedLayout = []
        //tabBar.barTintColor =  .lightGray
        tabBar.unselectedItemTintColor =  .lightGray
        tabBar.isTranslucent = false
        tabBar.barTintColor = UIColor.white
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white // change to your preferred color
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
    }
    
    private func setUpTabs() {
        let homeVC = ProfileController()
        let likesVC = FirstScreenController()
        let cartVC = FirstScreenController()
//        cartVC.delegate = self
        let profileVC =  ProfileController()
        let layout  = UICollectionViewFlowLayout()
        
       
        
//        let becomeSellerVC = sellerConroller
    
        
        
        homeVC.navigationItem.largeTitleDisplayMode = .automatic
        likesVC.navigationItem.largeTitleDisplayMode = .automatic
//        becomeSellerVC.navigationItem.largeTitleDisplayMode = .automatic
        profileVC.navigationItem.largeTitleDisplayMode = .automatic
        cartVC.navigationItem.largeTitleDisplayMode = .automatic
        
        
//        var nav3 = UINavigationController(rootViewController: becomeSellerVC)
//        if let onBoardingVC = becomeSellerVC as? OnBoardingLaunchViewController {
//            onBoardingVC.delegate = self
//            nav3 = UINavigationController(rootViewController: onBoardingVC)
//            
//        }
        
        
        let nav1 = UINavigationController(rootViewController: homeVC)
        let nav2 = UINavigationController(rootViewController: likesVC)
       
        let nav4 = UINavigationController(rootViewController: profileVC)
        let nav5 = UINavigationController(rootViewController: cartVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Home",
                                       image: UIImage(systemName: "house"),
                                       tag: 1)
        
        
        nav2.tabBarItem = UITabBarItem(title: "Likes",
                                       image: UIImage(systemName: "heart"),
                                       tag: 2)
//        nav3.tabBarItem = UITabBarItem(title: "Seller",
//                                       image: UIImage(systemName: "dollarsign.square"),
//                                       tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "You",
                                       image: UIImage(systemName: "person"),
                                       tag: 4)
        
        nav5.tabBarItem = UITabBarItem(title: "Basket",
                                       image: UIImage(systemName: "cart"),
                                       tag: 5)
        
        nav5.tabBarItem.badgeValue = "0"
        
        
        
        for nav in [nav1, nav2, nav4, nav5] {
            nav.navigationBar.prefersLargeTitles = false
        }
        
        setViewControllers(
            [nav1, nav2, nav4, nav5],
            animated: true
        )
    }
    
    
    
    
    
}
