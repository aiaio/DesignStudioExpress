//
//  UIButtonBlue.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/11/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class UIButtonBlue: UIButtonBase {
    
    let highlightedOpacity = CGFloat(0.8)
    override var defaultColor: UIColor { get { return UIColor(red:0.32, green:0.56, blue:0.86, alpha:1.0) /* #518EDC */ } }
    override var textColor:UIColor { get{ return DesignStudioStyles.white } }
    
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
