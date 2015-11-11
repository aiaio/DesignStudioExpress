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
    let buttonRadius = CGFloat(3)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // set rounded corners
        layer.cornerRadius = buttonRadius
        layer.borderWidth = 1
        
        // colors
        layer.borderColor = defaultColor.CGColor
        backgroundColor = defaultColor
        setTitleColor(textColor, forState: UIControlState.Normal)
        setTitleColor(textColor, forState: UIControlState.Highlighted)
        
        // font
        titleLabel?.font = UIFont(name: "Avenir-Light", size: 13)
    }
}
