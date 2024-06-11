//
//  ViewController.swift
//  solorise
//
//  Created by Navid Sheikh on 20/05/2024.
//

import UIKit

struct EmptyResponse: Codable {}

class FirstScreenController: UIViewController {
    
    
    private let logOutButton : UIButton =  {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        return button
    }()
    
    
    private let testButton : UIButton =  {
        let button = UIButton(type: .system)
        button.setTitle("testing", for: .normal)
        return button
    }()
    
    
    private func setUpViews (){
        view.addSubview(logOutButton)
        view.addSubview(testButton)
        
        let width  = self.view.frame.width * 0.6
        logOutButton.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, left: nil, right: nil, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: width, height: 100)
        logOutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        testButton.anchor(top: self.logOutButton.bottomAnchor, left: nil, right: nil, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: width, height: 100)
        testButton.addTarget(self, action: #selector(handleTestAuth), for: .touchUpInside)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemMint
        
        self.setUpViews()
        
        
        
    
        
        // Do any additional setup after loading the view.
//        NetworkManager.shared.test(expecting: ApiResponse<String>.self) { [weak self] result in
//            guard let self = self else {return}
//            switch result{
//            case .success(let result):
//                print(result)
//            case .failure(let error):
//                print("The error is")
//                print(error)
//            }
//            
//        }
    }
    
    @objc func handleLogout (){
        NetworkManager.shared.logout(expecting:  ApiResponse<EmptyResponse>.self) { [weak self] result in
            switch (result){
                
                
            case .success(_):
                print ("Successfully logout ")
            case .failure(_):
                print("Failed to logout")
            }
        }
    }
    
    @objc func handleTestAuth(){
        NetworkManager.shared.testAuth(expecting: [String : String].self) { [weak self] result in
            switch (result){
                
            case .success(_):
                print("By passed the middleware auth")
            case .failure(_):
                print ("Some error with this shit")
            }
        }
            }


}

