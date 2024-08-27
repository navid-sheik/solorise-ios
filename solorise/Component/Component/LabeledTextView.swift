//
//  LabeledTextView.swift
//  solorise
//
//  Created by Navid Sheikh on 17/08/2024.
//



import Foundation
import UIKit


class LabeledTextView: UIView, UITextViewDelegate {
    
    // MARK: - UI Components
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font =  UIFont.systemFont(ofSize: 14)
//        textView.backgroundColor = UIColor(red: 211, green: 211, blue: 211, alpha: 1)
//
        
//        textView.layer.masksToBounds = true
     
        return textView
    }()
    
    // MARK: - Properties
    var placeholderText: String
    
    var isPlaceholderActive = false
    
    // MARK: - Initializers
    init(labelText: String, placeholder: String) {
        self.placeholderText = placeholder
        super.init(frame: .zero)
        label.text = labelText
      
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        addSubview(label)
        addSubview(textView)
//        textView.layer.borderWidth = 1.0 // This sets the border width
//        textView.layer.borderColor = UIColor.lightGray.cgColor // This sets the border color
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 2, bottom: 8, right: 2)
        let lighterGray = DesignConstants.secondaryColor
        textView.backgroundColor = lighterGray


        
        // Set constraints for label
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // Set constraints for textView
        textView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
        textView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        textView.delegate = self
        
        // Setup toolbar
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [flexSpace, doneButton]
        textView.inputAccessoryView = toolbar
    }
    
    // MARK: - UITextViewDelegate Methods
    func textViewDidBeginEditing(_ textView: UITextView) {
       
      
      }


    func textViewDidEndEditing(_ textView: UITextView) {
     
    
    }

    
    @objc func doneButtonTapped() {
        textView.resignFirstResponder()
    }
}


