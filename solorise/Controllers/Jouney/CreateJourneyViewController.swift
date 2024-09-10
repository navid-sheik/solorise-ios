//
//  CreateJourneyController .swift
//  solorise
//
//  Created by Navid Sheikh on 05/09/2024.
//

import Foundation
import UIKit

class CreateJourneyViewController :  UIViewController{
    
    private let categoryService = CategoryService.shared
    private var selectedCategoryID: String?

    
    
    private let typeDropdown = Dropdown()
    private let typeButton : UIButton={
        let button  =  UIButton(type: .system)
        button.titleLabel?.textAlignment = .left
        //        button.backgroundColor  = .darkGray
        button.setTitle("Type", for: .normal)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    private let categoryDropdown = Dropdown()
    private let categoryButton : UIButton={
        let button  =  UIButton(type: .system)
        button.titleLabel?.textAlignment = .left
        //        button.backgroundColor  = .darkGray
        button.setTitle("Category", for: .normal)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    private let titlePostField : CustomTextField = {
        let textField = CustomTextField(fieldType: .custom)
        textField.placeholder = "Title"
        return textField
    }()
    
    ///Description
    let descriptionLabeledTexView :  LabeledTextView = {
        let labelTextView = LabeledTextView(labelText: "Description", placeholder: "Enter an appropriate description")
        labelTextView.translatesAutoresizingMaskIntoConstraints = false
        return labelTextView
    }()
    
    private let visibilityDropdown = Dropdown()
    private let visibilityButton : UIButton={
        let button  =  UIButton(type: .system)
        button.titleLabel?.textAlignment = .left
        //        button.backgroundColor  = .darkGray
        button.setTitle("Visibity", for: .normal)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    //Add challenge
    //Add date 
    
    
   
    
    private let createJourneyButton : CustomButton = {
        let button = CustomButton(title: "CREATE", hasBackground: true, fontType: .medium)
        button.addTarget(self, action: #selector(createJourneyTapped), for: .touchUpInside)
        return button
    }()
    
   
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .systemBackground
        
        // Handle category fetch success
        categoryService.onCategoriesFetched = { [weak self] in
            guard let strongSelf = self else { return }
            // Fetch the category names from the service
            let categoryNames = CategoryService.shared.categories.map { $0.name }
            
            // Update the dropdown's data source with the new category names
            strongSelf.categoryDropdown.updateDataSource(with: categoryNames)
        }
        
        // Handle errors
        categoryService.onError = { [weak self] errorMessage in
            guard let strongSelf = self else { return }
            
            let categoryNames = ["Error,please reload"]
//            self?.showErrorAlert(message: errorMessage)
            
            strongSelf.categoryDropdown.updateDataSource(with: categoryNames)
        }
        
        view.addSubview(titlePostField)
        titlePostField.delegate = self
        titlePostField.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, left: self.view.leadingAnchor, right: self.view.trailingAnchor, bottom: nil, paddingTop: 10, paddingLeft: 5, paddingRight: -5, paddingBottom: 0, width: nil, height: 50)
        
        
        
        
        descriptionLabeledTexView.textView.delegate = self
        view.addSubview(descriptionLabeledTexView)
        descriptionLabeledTexView.anchor( top: titlePostField.bottomAnchor , left: self.view.leadingAnchor, right: self.view.trailingAnchor, bottom: nil, paddingTop: 10, paddingLeft: 10,paddingRight:-10, paddingBottom: 0, width: nil, height: 200)
        
        
        view.addSubview(typeButton)
        typeButton.addTarget(self, action: #selector(typeSelect(_:)), for: .touchUpInside)
        typeButton.anchor(top: descriptionLabeledTexView.bottomAnchor, left: self.view.leadingAnchor, right: self.view.trailingAnchor, bottom: nil, paddingTop: 10, paddingLeft: 5, paddingRight: -5, paddingBottom: 0, width: nil, height: 50)
        
        view.addSubview(categoryButton)
        categoryButton.addTarget(self, action: #selector(categorySelect(_:)), for: .touchUpInside)
        categoryButton.anchor(top: typeButton.bottomAnchor, left: self.view.leadingAnchor, right: self.view.trailingAnchor, bottom: nil, paddingTop: 10, paddingLeft: 5, paddingRight: 5, paddingBottom: 0, width: nil, height: 50)
        
        view.addSubview(visibilityButton)
        visibilityButton.addTarget(self, action: #selector(visibilitySelect(_:)), for: .touchUpInside)
        visibilityButton.anchor(top: categoryButton.bottomAnchor, left: self.view.leadingAnchor, right: self.view.trailingAnchor, bottom: nil, paddingTop: 10, paddingLeft: 5, paddingRight: 5, paddingBottom: 0, width: nil, height: 50)
        
        
        view.addSubview(createJourneyButton)
        createJourneyButton.anchor(top: visibilityButton.bottomAnchor, left: self.view.leadingAnchor, right: self.view.trailingAnchor, bottom: nil, paddingTop: 10, paddingLeft: 10, paddingRight: -10, paddingBottom: 0, width: nil, height: 50)
        
    }
    
    @objc func typeSelect(_ sender: UIButton) {
        typeDropdown.showDropdown(on: sender, with: ["Grind", "Highlight", "Journal"])
    }
    
    
    @objc func categorySelect(_ sender: UIButton) {
        // Get the categories
        let categories = CategoryService.shared.categories

        // Prepare an array of category names
        let categoryNames = categories.map { $0.name }

        // Show the dropdown with category names
        categoryDropdown.showDropdown(on: sender, with: categoryNames)

        // Set up the category selection logic
        categoryDropdown.didSelectItem = { [weak self] selectedIndex in
            // Get the selected category's ID and name
            let selectedCategory = categories[selectedIndex]
            self?.categoryButton.setTitle(selectedCategory.name, for: .normal)
            self?.selectedCategoryID = selectedCategory.id // Save the category ID
        }
    }
    
    @objc func visibilitySelect(_ sender: UIButton) {
        typeDropdown.showDropdown(on: sender, with: ["Private", "Public"])
    }
    
    @objc func createJourneyTapped(_ sender: UIButton) {
        // Extract the journey title
        guard let title = titlePostField.text, !title.isEmpty else {
            print("Title is required")
            return
        }
        
        // Extract the journey description
        let description = descriptionLabeledTexView.textView.text ?? ""
        
        // Extract the selected type
        guard let type = typeButton.title(for: .normal), type != "Type" else {
            print("Please select a journey type")
            return
        }
        
        // Extract the selected category ID (use the stored category ID)
       guard let categoryID = selectedCategoryID else {
           print("Please select a category")
           return
       }
        // Extract the selected visibility
        guard let visibility = visibilityButton.title(for: .normal), visibility != "Visibility" else {
            print("Please select visibility")
            return
        }
        
        // 1. Create a new CreateJourneyRequest
        let createJourneyRequest = CreateJourneyRequest(
            title: title,
            description: description,
            category: categoryID,  // Assuming category is the ID
            type: type.lowercased(), // E.g., "grind"
            visibility: visibility.lowercased() // E.g., "public"
        )
        
        // 2. Send the CreateJourneyRequest using the NetworkManager
        NetworkManager.shared.createJourney(createJourneyRequest, expecting: ApiResponse<Journey>.self) { [weak self] result in
            switch result {
            case .success(let response):
                guard let journey  = response.data else {return}
                // Handle the successful creation of the journey (e.g., show a success message)
                
                DispatchQueue.main.async {
                    self?.showJourneyCreatedPopup()
                }
               
            case .failure(let error):
                // Handle the error (e.g., show an error message)
                print("Error creating journey: \(error.localizedDescription)")
            }
        }
    }
    
    func showJourneyCreatedPopup() {
        let alertController = UIAlertController(title: "Journey Created", message: "Your journey has been successfully created.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // You can add any additional actions here, like navigating back to the previous screen
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }


    
    
}
extension CreateJourneyViewController :  UITextViewDelegate{}
extension CreateJourneyViewController  : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
