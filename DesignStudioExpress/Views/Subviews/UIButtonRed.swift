//
//  UIButtonRed.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/10/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class UIButtonRed: UIButtonBase {
    
    let highlightedColor = DesignStudioStyles.secondaryOrange
    override var defaultColor: UIColor { get { return DesignStudioStyles.primaryOrange } }
    override var textColor:UIColor { get{ return DesignStudioStyles.white } }

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
