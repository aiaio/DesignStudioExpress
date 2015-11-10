//
//  UIButtonRed.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/10/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class UIButtonRed: UIButton {

    let defaultColor = UIColor(red:0.99, green:0.49, blue:0.42, alpha:1.0) // #FD7C6B
    let highlightedColor = UIColor(red:0.98, green:0.59, blue:0.55, alpha:1.0) // #FA968D
    let buttonRadius = CGFloat(3)

    override var highlighted: Bool {
        get {
            return super.highlighted
        }
        set {
            super.highlighted = newValue
            if newValue {
                backgroundColor = highlightedColor
                layer.borderColor = highlightedColor.CGColor
            } else {
                backgroundColor = defaultColor
                layer.backgroundColor = defaultColor.CGColor
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
        setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
    }
}
