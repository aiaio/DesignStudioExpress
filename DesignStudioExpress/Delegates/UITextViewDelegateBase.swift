//
//  UITextViewDelegateBase.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/1/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit
import SZTextView

class UITextViewDelegateBase: UITextDelegateBase, UITextViewDelegate {
    
    private var placeholder: String?
    
    // hide keyboard when the done button is pressed
    func textViewShouldReturn(textView: UITextField) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // hide placeholder when user starts editing
    func textViewDidBeginEditing(textView: UITextView) {
        if let szTextView = textView as? SZTextView {
            self.placeholder = szTextView.placeholder
            // placeholder is not optional
            szTextView.placeholder = ""
        }
    }
    
    // restore the placeholder value when user ends editing
    func textViewDidEndEditing(textView: UITextView) {
        if let szTextView = textView as? SZTextView {
            szTextView.placeholder = self.placeholder
            // placeholder is not optional
            self.placeholder = ""
        }
    }
}