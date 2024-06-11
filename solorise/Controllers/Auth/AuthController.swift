//
//  AuthController.swift
//  solorise
//
//  Created by Navid Sheikh on 08/06/2024.
//
import Foundation
import UIKit


class AuthViewContoller : UIViewController{
    
    // MARK: - Variables
//    private let viewMOdel = LoginViewModel()
    
    

    var completionHandler: ((Bool) -> Void)?
    
    private let authHeader = AuthHeaderView()
    
    
    
    private let slogan :  UILabel = {
        let label = UILabel()
        label.text = "Sell and buy personlized items for free"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment =  .center
        label.numberOfLines = 0
        return label
    }()
    
    
    private let signUpButton : CustomButton = {
        let button = CustomButton(title: "Sign up for PersonifyMe", hasBackground: true, fontType: .medium)

        return button
    }()
    
    private let loginButton : CustomButton = {
        let button = CustomButton(title: "I already have an account", hasBackground: false, fontType: .medium)
        button.layer.borderColor = DesignConstants.primaryColor?.cgColor
        button.layer.borderWidth =  2
        
        

        return button
    }()
    
//    private  let skipButton = CustomButton(title: "Skip", hasBackground: false, fontType: .medium)
    
    

   
//    private let signUpLabel : UILabel = {
//        let label = UILabel()
//        let attributedString1 = NSAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black , NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .light)])
//
//        let attributedString2 = NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemBlue, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
//
//        let combinedAttributedString = NSMutableAttributedString()
//        combinedAttributedString.append(attributedString1)
//        combinedAttributedString.append(attributedString2)
//        label.attributedText = combinedAttributedString
//        label.isUserInteractionEnabled = true
//
//
//
//        label.textAlignment = .center
//
//        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
//        return label
//    }()
//
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "DONE", style: .done, target: self, action: nil)
        view.backgroundColor =  .systemBackground
        
        loginButton.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(handleSignButton), for: .touchUpInside)
//        skipButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        self.setUpViews()
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        
       
    
    }
    
    
    private func setUpViews (){
        
//        view.addSubview(skipButton)
////        skipButton.backgroundColor =  .red
//        skipButton.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, left: nil, right: self.view.trailingAnchor, bottom: nil, paddingTop: 10, paddingLeft: 0, paddingRight: -15, paddingBottom: 0, width: nil, height: 20)
//        
        view.addSubview(authHeader)
        let width  = self.view.frame.width * 0.8
        authHeader.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, left: nil, right: nil, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: width, height: 100)
        authHeader.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        
        view.addSubview(loginButton)
        loginButton.anchor(top: nil, left: self.view.leadingAnchor, right: self.view.trailingAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, paddingTop: 0, paddingLeft: 20, paddingRight: -15, paddingBottom: -40, width: nil, height: 45)
        
        view.addSubview(signUpButton)
        signUpButton.anchor(top: nil, left: self.view.leadingAnchor, right: self.view.trailingAnchor, bottom: loginButton.topAnchor, paddingTop: 0, paddingLeft: 15, paddingRight: -15, paddingBottom: -15, width: nil, height: 45)
//
//        view.addSubview(slogan)
//        slogan.anchor(top: nil, left: self.view.leadingAnchor, right: self.view.trailingAnchor, bottom: loginButton.topAnchor, paddingTop: 0, paddingLeft: 30, paddingRight: -30, paddingBottom: -30, width: nil, height: nil)
//
//
        
        
        
        
        
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)

    }
    
    @objc func handleDismiss (){
        completionHandler?(false)
        self.dismiss(animated: true, completion: nil)
    
    }
    
    @objc func handleLoginButton(){
        let vc  =  LoginViewController()
//        let nav  = UINavigationController(rootViewController: vc)
        vc.completionHandler = completionHandler
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleSignButton(){
        let vc  =  SignupViewController()
        vc.completionHandler = completionHandler
        self.navigationController?.pushViewController(vc, animated: true)
    }
     
    

}

