//
//  UITextFieldDelegateMaxLength.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/25/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation
import UIKit

class UITextFieldDelegateMaxLength: UITextDelegateBase, UITextFieldDelegate {
    
    let maxLength: Int
    
    required init(maxLength length: Int) {
        self.maxLength = length
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return self.checkMaxLength((textField.text?.length)!, range: range, replacementStringLength: string.length, maxAllowedLength: self.maxLength)
    }
}