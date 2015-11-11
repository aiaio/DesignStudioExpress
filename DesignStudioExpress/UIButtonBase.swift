//
//  UIButtonBase.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/11/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class UIButtonBase: UIButton {

    let buttonRadius = CGFloat(3)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // set rounded corners
        layer.cornerRadius = buttonRadius
        layer.borderWidth = 1
    }


}
