//
//  SceneDelegate.swift
//  solorise
//
//  Created by Navid Sheikh on 20/05/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        CategoryService.shared.fetchCategories()
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene:  windowScene)
        

      
        let tabController  =  TabController()
        window.rootViewController = tabController
        
        self.window = window
        self.window?.makeKeyAndVisible()
        if AuthManager.getUser() == nil {
                let authViewController = AuthViewContoller()
                
                let navigationController = UINavigationController(rootViewController: authViewController)
                navigationController.modalPresentationStyle =  .fullScreen
                
                // Present the AuthViewController modally over the TabController
                tabController.present(navigationController, animated: true, completion: nil)
        }
        
    }
    
    
    
   


}

