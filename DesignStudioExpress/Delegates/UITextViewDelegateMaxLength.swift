//
//  UITextFieldDelegateBase.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/25/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation
import UIKit

class UITextViewDelegateMaxLength: UITextDelegateBase, UITextViewDelegate {
    
    let maxLength: Int
    
    required init(maxLength length: Int) {
        self.maxLength = length
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return self.checkMaxLength(textView.text.length, range: range, replacementStringLength: text.length, maxAllowedLength: self.maxLength)
    }
}