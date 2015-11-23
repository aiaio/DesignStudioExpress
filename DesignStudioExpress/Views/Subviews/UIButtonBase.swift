//
//  UIButtonRounded.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/11/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class UIButtonBase: UIButton {

    var defaultColor:UIColor { get{ return UIColor.whiteColor() } }
    var textColor:UIColor { get{ return UIColor.blueColor() } }
    let borderRadius = CGFloat(3)
    let titleFont = UIFont(name: "Avenir-Light", size: 13)
    let kerning: Float = 3.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // set rounded corners
        self.layer.cornerRadius = borderRadius
        self.layer.borderWidth = 1
        
        // colors
        self.layer.borderColor = defaultColor.CGColor
        self.backgroundColor = defaultColor
        self.setTitleColor(textColor, forState: UIControlState.Normal)
        self.setTitleColor(textColor, forState: UIControlState.Highlighted)
        
        // font
        self.titleLabel?.font = titleFont
        
        self.styleTitle(self.titleLabel?.text)
    }
    
    override func setTitle(title: String?, forState state: UIControlState) {
        super.setTitle(title, forState: state)
        
        self.styleTitle(title)
    }
    
    private func styleTitle(title: String?) {
        // set spacing between title characters to 3.0
        if title != nil {
            let attributedString = NSMutableAttributedString(string: title!)
            self.titleLabel?.attributedText = NSAttributedString.attributedStringWithSpacing(attributedString, kerning: kerning)
        }
    }
}