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
    let kerning = 3.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // set rounded corners
        layer.cornerRadius = borderRadius
        layer.borderWidth = 1
        
        // colors
        layer.borderColor = defaultColor.CGColor
        backgroundColor = defaultColor
        setTitleColor(textColor, forState: UIControlState.Normal)
        setTitleColor(textColor, forState: UIControlState.Highlighted)
        
        // font
        titleLabel?.font = titleFont
        
        // set spacing between title characters to 3.0
        let attributedString = titleLabel?.attributedText as! NSMutableAttributedString
        attributedString.addAttribute(NSKernAttributeName, value: kerning, range: NSMakeRange(0, attributedString.length))
        titleLabel?.attributedText = attributedString
    }
}