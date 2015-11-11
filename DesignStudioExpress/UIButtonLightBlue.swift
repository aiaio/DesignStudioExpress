//
//  UIButtonLightBlue.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/10/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class UIButtonLightBlue: UIButtonBase {
    
    
    override var defaultColor: UIColor { get { return UIColor(red:0.95, green:0.96, blue:0.97, alpha:1.0) } } // #F1F5F8
    override var textColor:UIColor { get{ return UIColor(red:0.49, green:0.50, blue:0.54, alpha:1.0) } } // #7E7F89
    let highlightedOpacity = CGFloat(0.8)
    
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
}
