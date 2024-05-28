//
//  ViewControllerExtension.swift
//  solorise
//
//  Created by Navid Sheikh on 28/05/2024.
//

import Foundation
import UIKit

extension UIViewController {
    
    private static var activityIndicatorAssocKey = "activityIndicatorAssocKey"
    
    var activityIndicator: UIActivityIndicatorView {
        if let activityIndicator = objc_getAssociatedObject(self, &UIViewController.activityIndicatorAssocKey) as? UIActivityIndicatorView {
            return activityIndicator
        } else {
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.hidesWhenStopped = true
            
            self.view.addSubview(activityIndicator)
            
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
            
            objc_setAssociatedObject(self, &UIViewController.activityIndicatorAssocKey, activityIndicator, .OBJC_ASSOCIATION_RETAIN)
            
            return activityIndicator
        }
    }
    
    func showLoading() {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.view.isUserInteractionEnabled = false
            }
        }
        
        func hideLoading() {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
}
