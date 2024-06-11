//
//  CustomButton.swift
//  solorise
//
//  Created by Navid Sheikh on 28/05/2024.
//
import Foundation
import UIKit


class CustomButton : UIButton {
    
    enum FontType {
        case big
        case medium
        case small
    }
    
    override var isEnabled: Bool {
       didSet {
           handleButtonStateChange()
       }
    }

    init(title : String, hasBackground : Bool  =  false,   fontType : FontType) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.backgroundColor =  hasBackground ?  DesignConstants.primaryColor : .clear
        self.layer.cornerRadius =  4
        let titleColor : UIColor = hasBackground ? .white :  DesignConstants.primaryColor!
        self.setTitleColor(titleColor, for: .normal)
        
        switch fontType {
            case .big:
                self.titleLabel?.font =  UIFont.systemFont(ofSize: 22)
            case .medium:
                self.titleLabel?.font =   UIFont.systemFont(ofSize: 16)
            case .small:
                self.titleLabel?.font =   UIFont.systemFont(ofSize: 12)
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    @objc private func handleButtonStateChange() {
           UIView.animate(withDuration: 0.3) {
               self.alpha = self.isEnabled ? 1.0 : 0.75
           }
    }
}

