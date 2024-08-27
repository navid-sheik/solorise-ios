//
//  MainEditor.swift
//  solorise
//
//  Created by Navid Sheikh on 04/08/2024.
//

import Foundation
import UIKit


class MainEditorViewController  : UIViewController {
    
    
    
    let mainImage : CustomImageView  = {
        let imageView  = CustomImageView()
//        imageView.image =  UIImage(named: "image-placeholder")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor =  .init(white: 0.9, alpha: 0.5)
        imageView.isUserInteractionEnabled = true // Enable user interaction
        return imageView
    }()
    
    private let postTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.masksToBounds = true
        textView.textAlignment = .left
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = true
        
        // Adding a placeholder label
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Enter your description"
        placeholderLabel.font = UIFont.systemFont(ofSize: 14)
        placeholderLabel.textColor = .lightGray
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        textView.addSubview(placeholderLabel)
        
        // Constraints for the placeholder label
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 8),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -8)
        ])
        
        // Adjust the visibility of the placeholder
       
        
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
    
    private let deleteMediaButton :  UIButton = {
        let button =  UIButton(type: .custom)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints  = false
        return button
    }()
    
    
    
    
    // Strong reference to the delegate
    private var placeholderDelegate: PlaceholderTextViewDelegate?
    private var postTextViewRightConstraint: NSLayoutConstraint?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .systemBackground
//        self.postTextView.delegate = self
        // Add tap gesture to dismiss keyboard
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
       view.addGestureRecognizer(tapGesture)
        setNavigationBar()
        setUpViews()
        
        linkButton.addTarget(self, action: #selector(handleAddLink) , for: .touchUpInside)
        imageButton.addTarget(self, action: #selector(handleImageCamera) , for: .touchUpInside)
        videoButton.addTarget(self, action: #selector(handleVideoCamera) , for: .touchUpInside)
        deleteMediaButton.addTarget(self, action: #selector(deleteImage) , for: .touchUpInside)
        
        
    }
    
    
  
    
    
    
    
    
    
    private func setNavigationBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "POST", style: .plain, target: self, action: #selector(didSendPost))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleCancelPost))
    }
    
    private func setUpViews() {
        let buttonStackView  =  StackManager.createStackView(with: [grindButton, highlightButton], axis: .horizontal, spacing: 5, distribution: .fillEqually, alignment: .fill)
        
        view.addSubview(postTextView)
        view.addSubview(mainImage)  // Add the mainImage below postTextView
        view.addSubview(buttonStackView)
        
        // Anchor mainImage under the postTextView\
        
        if mainImage.image != nil {
                view.addSubview(mainImage)
                
                // Anchor mainImage to the top right corner
                mainImage.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, right: self.view.trailingAnchor, bottom: nil, paddingTop: 10, paddingRight: -5, width: self.view.frame.width / 5, height: self.view.frame.height / 6)
                
                // Add deleteButton inside mainImage
                mainImage.addSubview(deleteMediaButton)
                deleteMediaButton.topAnchor.constraint(equalTo: mainImage.topAnchor).isActive = true
                deleteMediaButton.trailingAnchor.constraint(equalTo: mainImage.trailingAnchor).isActive = true
                deleteMediaButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
                deleteMediaButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
                self.deleteMediaButton.layer.zPosition = 1
                
                postTextView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, left: self.view.leadingAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: self.view.frame.height / 3)
                postTextViewRightConstraint = postTextView.trailingAnchor.constraint(equalTo: mainImage.leadingAnchor)
            } else {
                postTextView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, left: self.view.leadingAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: self.view.frame.height / 3)
                postTextViewRightConstraint = postTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            }
            postTextViewRightConstraint?.isActive = true
            



//        mainImage.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, right: self.view.trailingAnchor, bottom: nil, paddingTop: 10, paddingLeft: nil, paddingRight: -5, paddingBottom: 0, width: self.view.frame.width / 5, height: self.view.frame.height / 6)
//        
//        postTextView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, left: self.view.leadingAnchor, right: self.mainImage.leadingAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: nil, height: self.view.frame.height / 3)
        placeholderDelegate = PlaceholderTextViewDelegate(placeholderLabel: postTextView.subviews.first(where: { $0 is UILabel }) as! UILabel)
        postTextView.delegate = placeholderDelegate
   
        
        // Setup the toolbar and other buttons as before
        linkButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        videoButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        let toolBarStackView  =  StackManager.createStackView(with: [linkButton, imageButton, videoButton], axis: .horizontal, spacing: 5, distribution: .fill, alignment: .trailing)
        
        view.addSubview(toolBarStackView)
        view.addSubview(toolBarStackView)
        toolBarStackView.anchor(top: postTextView.bottomAnchor, left: nil, right: self.view.trailingAnchor, bottom: nil, paddingTop: 10, paddingLeft: 5, paddingRight: -5, paddingBottom: 0, width: nil, height: 30)
        
        buttonStackView.anchor(top: toolBarStackView.bottomAnchor, left: self.view.leadingAnchor, right: self.view.trailingAnchor, bottom: nil, paddingTop: 5, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: nil, height: nil)
        buttonStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(btnSelectFruit)
        btnSelectFruit.addTarget(self, action: #selector(onClickSelectFruit(_:)), for: .touchUpInside)
        btnSelectFruit.anchor(top: buttonStackView.bottomAnchor, left: self.view.leadingAnchor, right: self.view.trailingAnchor, bottom: nil, paddingTop: 0, paddingLeft: 5, paddingRight: -5, paddingBottom: 0, width: nil, height: 50)
        
        view.addSubview(btnSelectFruit2)
        btnSelectFruit2.addTarget(self, action: #selector(onClickSelectFruit2(_:)), for: .touchUpInside)
        btnSelectFruit2.anchor(top: btnSelectFruit.bottomAnchor, left: self.view.leadingAnchor, right: self.view.trailingAnchor, bottom: nil, paddingTop: 0, paddingLeft: 5, paddingRight: 5, paddingBottom: 0, width: nil, height: 50)
    }

    
    
    
    @objc func onClickSelectFruit(_ sender: UIButton) {
        dropdown.showDropdown(on: sender, with: ["Apple", "Mango", "Orange"])
    }
    
    
    @objc func onClickSelectFruit2(_ sender: UIButton) {
        dropdown2.showDropdown(on: sender, with: ["Apple", "Mango", "Orange"])
    }
    
    
    
    
    @objc func didSendPost() {
        print("Tapped send post")
        
        // Ensure the content is not empty
        guard let content = postTextView.text, !content.isEmpty else {
            print("Content cannot be empty")
            return
        }
        
        // Ensure a category is selected
        guard let category = btnSelectFruit.title(for: .normal), category != "Category" else {
            print("Please select a category")
            return
        }
        
        // Prepare the data to be sent in the POST request
        var postData: [String: Any] = [
            "content": content,
            "category": category
        ]
        
        // Add the image if it's available
        if let image = mainImage.image, let imageData = image.jpegData(compressionQuality: 0.8) {
            postData["file"] = imageData  // Add the image data directly, not as a base64 string
        }
        
        // Call the network manager to create the post
        NetworkManager.shared.createPost(postData, expecting: ApiResponse<Post>.self) { result in
            switch result {
            case .success(let response):
                guard let post = response.data else { return }
                print("Post created successfully: \(post)")
                // Handle successful post creation (e.g., navigate back or show confirmation)
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil) // Example of dismissing the view controller after post creation
                }
              
            case .failure(let error):
                print("Error creating post: \(error.localizedDescription)")
                // Handle the error (e.g., show an error message)
            }
        }
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
        controller.previewViewDelegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @objc func handleVideoCamera(){
        let controller =  SecondViewController()
        controller.previewViewDelegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // Action for delete button click
    @objc private func deleteImage() {
        // Remove the image and the delete button
        
        print("The delte button doesn't work")
        self.mainImage.image = nil
        self.deleteMediaButton.removeFromSuperview()

        // Remove mainImage from the view hierarchy
        self.mainImage.removeFromSuperview()

        // Adjust postTextView constraints to occupy the full width again
        self.postTextViewRightConstraint?.isActive = false
        self.postTextViewRightConstraint = self.postTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)
        self.postTextViewRightConstraint?.isActive = true

        // Force the view to update its layout immediately
        self.view.layoutIfNeeded()
    }
    // Function to dismiss the keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}



extension MainEditorViewController: PreviewViewControllerDelegate{
    
    
   
    func didSaveEditedImage(_ image: UIImage) {
        DispatchQueue.main.async { [self] in
            // Add the image view if it’s not already in the view hierarchy
            if self.mainImage.image == nil {
                self.view.addSubview(self.mainImage)

                // Anchor mainImage to the top right corner
                self.mainImage.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, right: self.view.trailingAnchor, bottom: nil, paddingTop: 10, paddingRight: -5, width: self.view.frame.width / 5, height: self.view.frame.height / 6)
                
                self.mainImage.addSubview(self.deleteMediaButton)
                self.deleteMediaButton.topAnchor.constraint(equalTo: self.mainImage.topAnchor).isActive = true
                self.deleteMediaButton.trailingAnchor.constraint(equalTo: mainImage.trailingAnchor).isActive = true
                self.deleteMediaButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
                self.deleteMediaButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
                self.deleteMediaButton.layer.zPosition = 1
                
                
                

                // Adjust postTextView constraints by deactivating the old constraint and adding a new one
                self.postTextViewRightConstraint?.isActive = false
                self.postTextViewRightConstraint = self.postTextView.trailingAnchor.constraint(equalTo: self.mainImage.leadingAnchor, constant: -10)
                self.postTextViewRightConstraint?.isActive = true
//                print("Somwhing")
            }

            // Update the image
            self.mainImage.image = image

            // Force the view to update its layout immediately
            self.view.layoutIfNeeded()
        }
    }


    
}
