//
//  MainEditor.swift
//  solorise
//
//  Created by Navid Sheikh on 04/08/2024.
//

import Foundation
import UIKit


class MainEditorViewController  : UIViewController {
    
    
    
    private let postTextView : UITextView = {
        let textView  =  UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.masksToBounds = true
        textView.text = "Enter your description "
        textView.textAlignment = .left
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5);
        textView.font = UIFont.systemFont(ofSize: 14)
        //        textView.layer.cornerRadius = 5
        //
        //        textView.layer.borderColor  =  UIColor.lightGray.cgColor
        //        textView.layer.borderWidth = 1
        textView.isScrollEnabled = true
        
        
        return textView
        
    }()
    
    
    private let grindButton  :  UIButton  = {
        
        let button  = UIButton ()
        button.setTitle("GRIND", for: .normal)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textAlignment =  .center
        button.backgroundColor = .black
        return button
        
    }()
    
    private let highlightButton   :  UIButton  = {
        
        let button  = UIButton ()
        button.setTitle("HIGHLIGHT", for: .normal)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textAlignment =  .center
        button.backgroundColor = .black
        return button
        
    }()
    
    let categoryTextView : UITextView =  {
        let textView =  UITextView()
        
        textView.text =  "Category"
        
        return textView
    }()
    
    private let dropdown = Dropdown()
    private let btnSelectFruit : UIButton={
        let button  =  UIButton(type: .system)
        button.titleLabel?.textAlignment = .left
        //        button.backgroundColor  = .darkGray
        button.setTitle("Category", for: .normal)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    private let dropdown2 = Dropdown()
    private let btnSelectFruit2 : UIButton={
        let button  =  UIButton(type: .system)
        button.titleLabel?.textAlignment = .left
        //        button.backgroundColor  = .darkGray
        button.setTitle("Category", for: .normal)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    
    private let  linkButton : UIButton =  {
        let button =  UIButton(type: .custom)
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let  imageButton : UIButton =  {
        let button =  UIButton(type: .custom)
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints =  false
        return button
    }()
    
    private let  videoButton : UIButton =  {
        let button =  UIButton(type: .custom)
        button.setImage(UIImage(systemName: "play.rectangle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints  = false
        return button
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .systemBackground
        self.postTextView.delegate = self
        setNavigationBar()
        setUpViews()
        
        linkButton.addTarget(self, action: #selector(handleAddLink) , for: .touchUpInside)
        imageButton.addTarget(self, action: #selector(handleImageCamera) , for: .touchUpInside)
        videoButton.addTarget(self, action: #selector(handleVideoCamera) , for: .touchUpInside)
        
    }
    
    
    
    
    
    
    
    private func setNavigationBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "POST", style: .plain, target: self, action: #selector(didSendPost))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleCancelPost))
    }
    
    private func setUpViews(){
        
        
        let buttonStackView  =  StackManager.createStackView(with: [grindButton, highlightButton] , axis: .horizontal, spacing: 5, distribution: .fillEqually, alignment: .fill)
        view.addSubview(postTextView)
        view.addSubview(buttonStackView)
        postTextView.anchor( top: self.view.topAnchor, left: self.view.leadingAnchor, right: self.view.trailingAnchor, bottom :  nil, paddingTop: 0, paddingLeft: 0,paddingRight: 0, paddingBottom: 0, width: nil, height: self.view.frame.height / 2)
        
        
        //        linkButton.heightAnchor.constraint(equalToConstant: 30).isActive  = true
        linkButton.widthAnchor.constraint(equalToConstant: 30).isActive  = true
        //        imageButton.heightAnchor.constraint(equalToConstant: 30).isActive  = true
        imageButton.widthAnchor.constraint(equalToConstant: 30).isActive  = true
        
        //        videoButton.heightAnchor.constraint(equalToConstant: 30).isActive  = true
        videoButton.widthAnchor.constraint(equalToConstant: 30).isActive  = true
        
        let toolBarStackView  =  StackManager.createStackView(with: [linkButton, imageButton, videoButton] , axis: .horizontal, spacing: 5, distribution: .fill, alignment: .trailing)
        
        view.addSubview(toolBarStackView)
        
        toolBarStackView.anchor( top: postTextView.bottomAnchor, left: nil, right: self.view.trailingAnchor, bottom :  nil, paddingTop: 10, paddingLeft: 5,paddingRight: -5, paddingBottom: 0, width: nil, height: 30)
        
        
        
        
        buttonStackView.anchor( top: toolBarStackView.bottomAnchor, left: self.view.leadingAnchor, right: self.view.trailingAnchor, bottom :  nil, paddingTop: 5, paddingLeft: 0,paddingRight: 0, paddingBottom: 0, width: nil, height: nil)
        buttonStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        
        
        
        view.addSubview(btnSelectFruit)
        
        btnSelectFruit.addTarget(self, action: #selector(onClickSelectFruit(_:)), for: .touchUpInside)
        btnSelectFruit.anchor( top: buttonStackView.bottomAnchor, left: self.view.leadingAnchor, right: self.view.trailingAnchor, bottom :  nil, paddingTop: 0, paddingLeft: 5,paddingRight: -5, paddingBottom: 0, width: nil, height: 50)
        
        view.addSubview(btnSelectFruit2)
        btnSelectFruit2.addTarget(self, action: #selector(onClickSelectFruit2(_:)), for: .touchUpInside)
        btnSelectFruit2.anchor( top: btnSelectFruit.bottomAnchor, left: self.view.leadingAnchor, right: self.view.trailingAnchor, bottom :  nil, paddingTop: 0, paddingLeft: 5,paddingRight: 5, paddingBottom: 0, width: nil, height: 50)
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
        
        
        
        
    }
    
    
    
    @objc func onClickSelectFruit(_ sender: UIButton) {
        dropdown.showDropdown(on: sender, with: ["Apple", "Mango", "Orange"])
    }
    
    
    @objc func onClickSelectFruit2(_ sender: UIButton) {
        dropdown2.showDropdown(on: sender, with: ["Apple", "Mango", "Orange"])
    }
    
    
    
    
    @objc func didSendPost(){
        print("Tapped send post")
    }
    @objc func handleCancelPost(){
        print("Tapped cancel post")
        self.dismiss(animated: true)
    }
    
    
    @objc func handleAddLink(){
        print("Add the link url")
    }
    
    @objc func handleImageCamera(){
        let controller =  SecondViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @objc func handleVideoCamera(){
        let controller =  SecondViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension MainEditorViewController :  UITextViewDelegate{
    
    // UITextViewDelegate method to detect the return key
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                // Dismiss the keyboard
                textView.resignFirstResponder()
                return false
            }
            return true
        }
    
}
