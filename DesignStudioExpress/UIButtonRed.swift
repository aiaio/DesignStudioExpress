//
//  UIButtonRed.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/10/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class UIButtonRed: UIButtonBase {
    
    let highlightedColor = UIColor(red:0.98, green:0.59, blue:0.55, alpha:1.0) // #FA968D
    override var defaultColor: UIColor { get { return UIColor(red:0.99, green:0.49, blue:0.42, alpha:1.0) } } // #FD7C6B
    override var textColor:UIColor { get{ return UIColor.whiteColor() } }

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
}
