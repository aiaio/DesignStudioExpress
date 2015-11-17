//
//  DetailDesignStudioViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/15/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class DetailDesignStudioViewController: BaseUIViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var name: UITextView!
    @IBOutlet weak var duration: UITextField!
    @IBOutlet weak var continueButton: UIButtonRed!
    
    let vm = DetailDesignStudioViewModel()

    var activeField: UIView?
    var changedY = false
    var keyboardHeight: CGFloat = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.delegate = self
        duration.delegate = self
        
        self.addObservers()
        self.populateFields()
        
        var frameRect = name.frame;
        frameRect.size.height = 100;
        name.frame = frameRect;
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        activeField = nil
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var fieldName: DetailDesignStudioViewModel.FieldNames
        if textField == self.name {
            fieldName = .Title
        } else if textField == self.duration {
            fieldName = .Duration
        } else {
            return false
        }
        
        return vm.maxLengthExceeded(fieldName, textFieldLength: (textField.text?.length)!, range: range, replacementStringLength: string.length)
    }
    
    // MARK: - Actions
    
    @IBAction func textFieldEditingDidBegin(sender: UITextField){
        activeField = sender
    }
    
    @IBAction func textFieldEditingDidEnd(sender: UITextField) {
        activeField = nil
    }
    
    // hide any active keyboard when background is touched
    @IBAction func backgroundTouched(sender: AnyObject) {
        activeField?.resignFirstResponder()
        activeField = nil
    }
    
    // MARK: - custom
    
    func addObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"),
            name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"),
            name:UIKeyboardWillHideNotification, object: nil);
    }
    
    func keyboardWillShow(sender: NSNotification) {
        let kbSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        
        keyboardHeight = kbSize!.height
        var aRect = self.view.frame;
        aRect.size.height = aRect.size.height - kbSize!.height - CGFloat(20);

        if activeField != nil && !CGRectContainsPoint(aRect, activeField!.frame.origin) {
            if (!changedY) {
                self.view.frame.origin.y -= keyboardHeight
            }
            changedY = true
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if changedY {
            self.view.frame.origin.y += keyboardHeight
        }
        changedY = false
    }
    
    func populateFields () {
        self.name.text = vm.getTitle()
        self.duration.text = vm.getDuration()
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
