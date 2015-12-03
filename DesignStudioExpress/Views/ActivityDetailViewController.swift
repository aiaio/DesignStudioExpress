//
//  ActivityDetailViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/1/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation
import UIKit
import SZTextView
import GMStepper

class ActivityDetailViewController: UITableViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var duration: GMStepper!
    @IBOutlet weak var activityDescription: SZTextView!
    @IBOutlet weak var notes: SZTextView!
    
    let vm = ActivityDetailViewModel()
    
    let nameDelegate = UITextFieldDelegateMaxLength(maxLength: 30)
    let descriptionDelegate = UITextViewDelegateMaxLength(maxLength: 150)
    let notesDelegate = UITextViewDelegateMaxLength(maxLength: 150)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerDelegates()
        self.customizeStyle()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.populateFields()
    }
    
    @IBAction func saveActivity(sender: AnyObject) {
        self.updateVMData()
        // don't forget to persist the changes
        vm.saveActivity()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func deleteActivity(sender: AnyObject) {
        vm.deleteActivity()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Custom
    
    func registerDelegates() {
        self.name.delegate = nameDelegate
        self.activityDescription.delegate = descriptionDelegate
        self.notes.delegate = notesDelegate
    }
    
    func customizeStyle() {
        // remove the separator from the last row; works when we have only one section
        self.tableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 1))
        
        // customize the look of the stepper
        self.duration.labelFont = UIFont(name: "Avenir-Book", size: 18)!
        self.duration.buttonsFont = UIFont(name: "Avenir-Book", size: 20)!
        self.duration.leftButtonText = "–" // N-dash, so it's a little bit longer
    }
    
    func populateFields () {
        self.name.text = vm.title
        self.duration.value = Double(vm.duration)
        self.activityDescription.text = vm.description
        self.notes.text = vm.notes
    }
    
    func updateVMData() {
        vm.title = self.name.text?.length > 0 ?  self.name.text! : self.name.placeholder!
        vm.duration = Int(self.duration.value)
        vm.description = self.activityDescription.text?.length > 0 ?  self.activityDescription.text! : self.activityDescription.placeholder!
        vm.notes = self.notes.text?.length > 0 ?  self.notes.text! : ""
    }
}