//
//  PlaceholderTextViewDelegate.swift
//  solorise
//
//  Created by Navid Sheikh on 18/08/2024.
//

import Foundation
import UIKit

class PlaceholderTextViewDelegate: NSObject, UITextViewDelegate {
    private weak var placeholderLabel: UILabel?
    
    init(placeholderLabel: UILabel) {
        self.placeholderLabel = placeholderLabel
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderLabel?.text
            textView.textColor = .lightGray
        }
    }
    
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
