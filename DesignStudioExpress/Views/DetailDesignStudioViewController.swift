//
//  DetailDesignStudioViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/15/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class DetailDesignStudioViewController: UIViewControllerBase, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var name: UITextView!
    @IBOutlet weak var duration: UITextField!
    @IBOutlet weak var challenges: UILabel!
    @IBOutlet weak var continueButton: UIButtonRed!
    
    let vm = DetailDesignStudioViewModel()
    
    let openDesignStudioSegue = "OpenDesignStudio"
    var changedY = false
    var keyboardHeight: CGFloat = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.delegate = self
        duration.delegate = self
        
        self.addObservers()
        self.populateFields()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.populateFields()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.updateData()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return vm.maxLengthExceeded(.Duration, textFieldLength: (textField.text?.length)!, range: range, replacementStringLength: string.length)
    }
    
    // MARK: - UITextViewDelegate
        
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return vm.maxLengthExceeded(.Title, textFieldLength: (textView.text?.length)!, range: range, replacementStringLength: text.length)
    }
    
    // activate keyboard whenever the whole UIControl parent for duration is touched
    @IBAction func durationBackgroundTouched(sender: AnyObject) {
        self.duration.becomeFirstResponder()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == self.openDesignStudioSegue {
            let data = vm.openDesignStudio(self.name.text, duration: self.duration.text!)
            
            let destination = segue.destinationViewController as! ChallengesViewController
            destination.vm.setDesignStudio(data)
        }
        
        // close the keyboard so that we don't have layouting problems when switching back to the screen
        self.name.resignFirstResponder()
    }
    
    // MARK: - custom
    
    override func customizeNavBarStyle() {
        super.customizeNavBarStyle()
        
        DesignStudioElementStyles.transparentNavigationBar(self.navigationController!.navigationBar)
    }
    
    func addObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"),
            name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"),
            name:UIKeyboardWillHideNotification, object: nil);
    }
    
    func populateFields () {
        self.name.text = vm.title
        self.duration.text = vm.duration
        self.challenges.text = vm.challenges
        // title of the button is different for new and existing design studios
        self.continueButton.setTitle(vm.buttonTitle, forState: .Normal)
    }
    
    func updateData() {
        vm.title = self.name.text!
    }
    
    func keyboardWillShow(sender: NSNotification) {
        let kbSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        
        keyboardHeight = kbSize!.height
        var aRect = self.view.frame;
        aRect.size.height = aRect.size.height - kbSize!.height - CGFloat(20);

        if (!changedY) {
            self.view.frame.origin.y -= keyboardHeight
        }
        changedY = true
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if changedY {
            self.view.frame.origin.y += keyboardHeight
        }
        changedY = false
    }
}
