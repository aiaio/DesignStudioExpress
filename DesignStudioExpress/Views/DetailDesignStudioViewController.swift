//
//  DetailDesignStudioViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/15/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit
import SZTextView
import FXLabel

class DetailDesignStudioViewController: UIViewControllerBase {
    
    enum NotificationIdentifier: String {
        case DesignStudioCopied = "DesignStudioCopied"
    }
    
    @IBOutlet weak var name: SZTextView!
    @IBOutlet weak var duration: UITextField!
    @IBOutlet weak var challenges: UILabel!
    @IBOutlet weak var continueButton: UIButtonRed!
    @IBOutlet weak var editIcon: UIImageView!
    @IBOutlet weak var editLabel: FXLabel!
    
    let vm = DetailDesignStudioViewModel()
    
    let nameDelegate = UITextViewDelegateMaxLength(maxLength: 28)
    let durationDelegate = UITextFieldDelegateMaxLength(maxLength: 100) 
    
    let openDesignStudioSegue = "OpenDesignStudio"
    var changedY = false
    var keyboardHeight: CGFloat = 300
    
    let copyErrorTitle = "Whoa"
    let copyErrorMessage = "Couldn't create a copy"
    
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
    
    @IBAction func copyDesignStudio(sender: AnyObject) {
        if let copy = self.vm.copyDesignStudio() {
            let notificationData = ["DesignStudio":copy]
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationIdentifier.DesignStudioCopied.rawValue, object: self, userInfo: notificationData)
        } else {
            let alertController = UIAlertController.createAlertController(self.copyErrorTitle, message: self.copyErrorMessage)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
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
        
        // make the back button clear, so that it's invisible when we're transitioning to the same screen
        self.navigationController?.navigationBar.tintColor = UIColor.clearColor()
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
        self.editIcon.image = UIImage(named: vm.editIconImage)
        self.editLabel.hidden = !vm.editingEnabled
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
