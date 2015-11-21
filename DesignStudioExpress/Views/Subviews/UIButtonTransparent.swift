//
//  UIButtonTransparent.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/21/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class UIButtonTransparent: UIButtonBase {
    override var defaultColor: UIColor { get { return UIColor.clearColor() } }
    override var textColor:UIColor { get{ return DesignStudioStyles.secondaryOrange } }
}
