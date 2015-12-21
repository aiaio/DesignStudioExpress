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
    @IBOutlet weak var saveActivity: UIButtonRed!
    @IBOutlet weak var deleteActivity: UIButtonTransparent!
    @IBOutlet weak var deleteActivityButtonHeightConstraint: NSLayoutConstraint!
    
    let vm = ActivityDetailViewModel()
    
    let nameDelegate = UITextFieldDelegateMaxLength(maxLength: 25)
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
        self.enableDisableFields()
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 110
        case 1: return 80
        case 2: return 180
        case 3: return 180
        case 4:
            // change the height of the last cell
            // so that we don't have empty space when hiding the button
            if vm.locked {
                return 80
            }
            return 160
        default:
            return 80
        }
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
    
    func enableDisableFields() {
        self.name.enabled = vm.editingEnabled
        self.activityDescription.editable = vm.editingEnabled
        self.duration.enabled = vm.editingEnabled
        self.notes.editable = !vm.locked // disable notes only for template studios; notes for finished studios are editable
    
        // hide and change the height of the Delete activity
        // so that we don't have empty space at the end of the cell
        // for smaller screens
        self.deleteActivityButtonHeightConstraint.constant = 50
        if !vm.editingEnabled || vm.locked {
            self.deleteActivityButtonHeightConstraint.constant = 0
        }
        self.deleteActivity.hidden = !vm.editingEnabled || vm.locked
        self.saveActivity.setTitle(self.vm.saveActivityLabel, forState: .Normal)
    }
    
    func updateVMData() {
        vm.title = self.name.text?.length > 0 ?  self.name.text! : self.name.placeholder!
        vm.duration = Int(self.duration.value)
        vm.description = self.activityDescription.text?.length > 0 ?  self.activityDescription.text! : self.activityDescription.placeholder!
        vm.notes = self.notes.text?.length > 0 ?  self.notes.text! : ""
    }
}