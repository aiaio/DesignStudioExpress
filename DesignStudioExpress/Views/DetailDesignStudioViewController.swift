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
        vm.setDuration(textField.text!)
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return vm.maxLengthExceeded(.Duration, textFieldLength: (textField.text?.length)!, range: range, replacementStringLength: string.length)
    }
    
    // MARK: - UITextViewDelegate
        
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            vm.setTitle(textView.text!)
            return false
        }
        return vm.maxLengthExceeded(.Title, textFieldLength: (textView.text?.length)!, range: range, replacementStringLength: text.length)
    }
    
    // hide any active keyboard when background is touched
    @IBAction func backgroundTouched(sender: AnyObject) {
        self.name.resignFirstResponder()
        self.duration.resignFirstResponder()
        
        vm.setTitle(self.name.text!)
        vm.setDuration(self.duration.text!)
    }
    
    // activate keyboard whenever the whole UIControl parent for duration is touched
    @IBAction func durationBackgroundTouched(sender: AnyObject) {
        self.duration.becomeFirstResponder()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == self.openDesignStudioSegue {
            vm.openDesignStudio(self.name.text, duration: self.duration.text!)
            /*
            let destination = segue.destinationViewController as! ChallengesViewController
            destination.vm.setDesignStudio(sender as? DesignStudio)*/
        }
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
    
    func populateFields () {
        self.name.text = vm.getTitle()
        self.duration.text = vm.getDuration()
        self.continueButton.setTitle(vm.getButtonTitle(), forState: .Normal)
    }
}
