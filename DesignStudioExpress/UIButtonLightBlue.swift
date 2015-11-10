//
//  UIButtonLightBlue.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/10/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class UIButtonLightBlue: UIButton {
    
    let defaultColor = UIColor(red:0.95, green:0.96, blue:0.97, alpha:1.0) // #F1F5F8
    let textColor = UIColor(red:0.49, green:0.50, blue:0.54, alpha:1.0) // #7E7F89
    let highlightedOpacity = CGFloat(0.8)
    let buttonRadius = CGFloat(3)
    
    override var highlighted: Bool {
        get {
            return super.highlighted
        }
        set {
            super.highlighted = newValue
            if newValue {
                self.alpha = highlightedOpacity
            } else {
                self.alpha = 1.0
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // set rounded corners
        layer.cornerRadius = buttonRadius
        layer.borderWidth = 1
        layer.borderColor = defaultColor.CGColor
        
        // colors
        backgroundColor = defaultColor
        setTitleColor(textColor, forState: UIControlState.Normal)
        setTitleColor(textColor, forState: UIControlState.Highlighted)
    }
}
