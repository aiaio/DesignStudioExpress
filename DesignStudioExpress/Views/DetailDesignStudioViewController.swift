//
//  DetailDesignStudioViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/15/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit
import SZTextView

class DetailDesignStudioViewController: UIViewControllerBase {
    
    @IBOutlet weak var name: SZTextView!
    @IBOutlet weak var duration: UITextField!
    @IBOutlet weak var challenges: UILabel!
    @IBOutlet weak var continueButton: UIButtonRed!
    @IBOutlet weak var editIcon: UIImageView!
    
    let vm = DetailDesignStudioViewModel()
    
    let nameDelegate = UITextViewDelegateMaxLength(maxLength: 20) // TODO adjust max length
    let durationDelegate = UITextFieldDelegateMaxLength(maxLength: 100) // TODO adjust max legnth
    
    let openDesignStudioSegue = "OpenDesignStudio"
    var changedY = false
    var keyboardHeight: CGFloat = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.delegate = nameDelegate
        duration.delegate = durationDelegate
        
        self.addObservers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.populateFields()
        self.disableEnableFields()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.updateData()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    // activate keyboard whenever the whole UIControl parent for duration is touched
    @IBAction func durationBackgroundTouched(sender: AnyObject) {
        self.duration.becomeFirstResponder()
    }
    
    @IBAction func editIconTapped(sender: AnyObject) {
        self.name.becomeFirstResponder()
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
    
    // MARK: StyledNavigationBar
    
    override func customizeNavBarStyle() {
        super.customizeNavBarStyle()
        
        DesignStudioElementStyles.transparentNavigationBar(self.navigationController!.navigationBar)
    }
    
    // MARK: - custom
    
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
    
    func disableEnableFields() {
        self.name.editable = vm.editingEnabled
        self.duration.enabled = vm.editingEnabled
        self.editIcon.hidden = !vm.editingEnabled
    }
    
    func updateData() {
        if self.name.text?.length > 0 {
            vm.title = self.name.text!
        } else {
            vm.title = self.name.placeholder
        }
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
