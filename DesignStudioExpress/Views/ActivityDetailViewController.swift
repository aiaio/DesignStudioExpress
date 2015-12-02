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

class ActivityDetailViewController: UITableViewController {
    
    @IBOutlet weak var name: UITextField!
    //@IBOutlet weak var duration: UITextField!
    @IBOutlet weak var activityDescription: SZTextView!
    @IBOutlet weak var notes: SZTextView!
    
    let vm = ActivityDetailViewModel()
    
    let nameDelegate = UITextFieldDelegateMaxLength(maxLength: 30)
    let descriptionDelegate = UITextViewDelegateMaxLength(maxLength: 150)
    let notesDelegate = UITextViewDelegateMaxLength(maxLength: 150)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.name.delegate = nameDelegate
        self.activityDescription.delegate = descriptionDelegate
        self.notes.delegate = notesDelegate
        
        self.customizeStyle()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.populateFields()
    }
    
    // MARK: - Custom
    
    func customizeStyle() {
        // remove the separator from the last row; works when we have only one section
        self.tableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 1))
    }
    
    func populateFields () {
        self.name.text = vm.title
        //self.duration.text = vm.duration
        self.activityDescription.text = vm.description
        self.notes.text = vm.notes
    }
    
    @IBAction func saveActivity(sender: AnyObject) {
        vm.title = self.name.text?.length > 0 ?  self.name.text! : self.name.placeholder!
        vm.description = self.activityDescription.text?.length > 0 ?  self.activityDescription.text! : self.activityDescription.placeholder!
        vm.notes = self.notes.text?.length > 0 ?  self.notes.text! : self.notes.placeholder!

        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func deleteActivity(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}