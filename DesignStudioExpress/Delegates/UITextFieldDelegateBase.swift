//
//  UITextFieldDelegateBase.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/1/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class UITextFieldDelegateBase: UITextDelegateBase, UITextFieldDelegate {
    
    private var placeholder: String?
    
    // hide keyboard when the done button is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // hide placeholder when user starts editing
    func textFieldDidBeginEditing(textField: UITextField) {
        self.placeholder = textField.placeholder
        textField.placeholder = nil
    }
    
    // restore the placeholder value when user ends editing
    func textFieldDidEndEditing(textField: UITextField) {
        textField.placeholder = self.placeholder
        self.placeholder = nil
    }
}