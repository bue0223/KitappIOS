//
//  RoundButton.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 5/25/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    override var isHighlighted: Bool {
        didSet {

            let xScale : CGFloat = isHighlighted ? 1.025 : 1.0
            let yScale : CGFloat = isHighlighted ? 1.05 : 1.0
            UIView.animate(withDuration: 0.1) {
                let transformation = CGAffineTransform(scaleX: xScale, y: yScale)
                self.transform = transformation
            }
        }
    }

}

@IBDesignable class RoundButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }
    
    
    var title: String = "" {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    
    var isButtonEnabled = true {
        didSet {
            isEnabled = isButtonEnabled
            refreshButton()
        }
    }
    
    
    @IBInspectable var isInverted = false {
        didSet {
            refreshButton()
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            ///refreshBorder()
            //refreshButton()
        }
    }
    
    @IBInspectable var colorTheme: UIColor = .clear {
        didSet {
            refreshButton()
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        refreshCorners(value: cornerRadius)
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = bounds.height / 2
        
        dropShadowButton()
    }
    
    func refreshButton() {
        layer.borderWidth = isInverted == false ? 0.0 : 2.0
        layer.borderColor = isInverted == false ? UIColor.clear.cgColor : colorTheme.cgColor
        backgroundColor = isInverted == false ? colorTheme : UIColor.white
        setTitleColor(isInverted == false ? UIColor.white : colorTheme, for: .normal)
        alpha = isButtonEnabled == true ? 1.0 : 0.50
        
        //To apply Shadow
        layer.shadowOpacity = 1
        layer.shadowRadius = 4.0
        layer.shadowOffset = CGSize.zero // Use any CGSize
        layer.shadowColor = UIColor.black.cgColor
    }
    
     
    override var isHighlighted: Bool {
        didSet {
            let xScale : CGFloat = isHighlighted ? 1.025 : 1.0
            let yScale : CGFloat = isHighlighted ? 1.05 : 1.0
            UIView.animate(withDuration: 0.1) {
                let transformation = CGAffineTransform(scaleX: xScale, y: yScale)
                self.transform = transformation
            }
        }
    }
}
