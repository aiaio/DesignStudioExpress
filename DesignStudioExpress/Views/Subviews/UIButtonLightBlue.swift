//
//  UIButtonLightBlue.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/10/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class UIButtonLightBlue: UIButtonBase {
    
    
    override var defaultColor: UIColor { get { return DesignStudioStyles.secondaryButton } }
    override var textColor:UIColor { get{ return DesignStudioStyles.secondaryButtonText } }
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
