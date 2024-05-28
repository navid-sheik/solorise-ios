//
//  StackManager.swift
//  solorise
//
//  Created by Navid Sheikh on 28/05/2024.
//

import Foundation
import UIKit

final class StackManager{

    ///Create a stackView
    static func createStackView(with views: [UIView], axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 0, distribution: UIStackView.Distribution = .fill , alignment: UIStackView.Alignment = .fill) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = distribution
        stackView.alignment = alignment
        stackView.isUserInteractionEnabled = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    static func createStackViewWithLabels(with views: [UIView]) -> UIStackView {
        let stackView = StackManager.createStackView(with: views, axis: .vertical, spacing: 2, distribution: .fillEqually, alignment: .fill)
        stackView.isUserInteractionEnabled = true
        return stackView
    }
    
    ///Create Constrainsted stackview- not working
    static func createConstrainedStackView(with views: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat, width: CGFloat, height: CGFloat) -> UIStackView {
        views.forEach {
            $0.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        let stackView = createStackView(with: views, axis: axis, spacing: spacing)
        stackView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        return stackView
    }
}
