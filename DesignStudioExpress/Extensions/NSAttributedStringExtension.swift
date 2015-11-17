//
//  NSAttributedStringExtension.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/16/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    // creates an attributed string with spacing (kerning)
    class func attributedStringWithSpacing(text: NSAttributedString, kerning: Float) -> NSMutableAttributedString {
        let attributedString = text as! NSMutableAttributedString
        attributedString.addAttribute(NSKernAttributeName, value: kerning, range: NSMakeRange(0, attributedString.length))
        return attributedString
    }
}