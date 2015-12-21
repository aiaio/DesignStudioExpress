//
//  ChallengeDetailViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/21/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit
import SZTextView

class ChallengeDetailViewController: UIViewControllerBase, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate {
    enum SegueIdentifier: String {
        case EditActivity = "EditActivity"
        case AddActivity = "AddActivity"
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addActivityButton: UIButtonRed!
    @IBOutlet weak var actionButtonHeightConstraint: NSLayoutConstraint!
    
    // store the text elements in a weak var for easy retrieval
    weak var headerTitle: UITextField?
    weak var headerDescription: SZTextView? // contains placeholder

    let vm = ChallengeDetailViewModel()
    
    let titleDelegate = UITextFieldDelegateMaxLength(maxLength: 28)
    let descriptionDelegate = UITextViewDelegateMaxLength(maxLength: 200)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the title
        self.navigationItem.title = vm.designStudioTitle
        
        self.addObservers()
        self.customizeStyle()
        self.prepareViewState()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.updateData()
    }
    
    @IBAction func editIconTapped(sender: AnyObject) {
        self.headerTitle?.becomeFirstResponder()
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return vm.getTotalRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.row == 0 {
            let cell = self.createCell("headerCell", indexPath: indexPath, UITableViewCellChallengeHeader.self)
            
            cell.title.delegate = self.titleDelegate
            cell.challengeDescription.delegate = self.descriptionDelegate
            
            cell.title.text = vm.challengeTitle
            cell.challengeDescription.text = vm.challengeDescription
            cell.duration.text = vm.challengeDuration
            
            // save the references to the elements in the headers
            // so that we have easy access when we need to resign first responders
            self.headerTitle = cell.title
            self.headerDescription = cell.challengeDescription
            
            cell.title.enabled = vm.editingEnabled
            cell.challengeDescription.editable = vm.editingEnabled
            cell.editIcon.hidden = !vm.editingEnabled
            
            // hide separator
            cell.separatorInset = UIEdgeInsetsMake(0, self.view.frame.width, 0, 0);
            return cell
        }
      
        let cell = self.createCell("activityCell", indexPath: indexPath, UITableViewCellActivity.self)
        cell.title.text = vm.activityTitle(indexPath)
        cell.activityDescription.text = vm.activityDescription(indexPath)
        cell.duration.text = vm.activityDuration(indexPath)
        cell.details.text = vm.activityDetails(indexPath)
        cell.actionButton.setTitle(vm.actionButtonText, forState: .Normal)
        
        // set separator from edge to edge
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        }
        return 155
    }
    
    // Don't show delete/insert controls when editing
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    // Don't indent rows when editing
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        // hide keyboard when we're scrolling
        self.headerTitle?.resignFirstResponder()
        self.headerDescription?.resignFirstResponder()
    }
    
    // MARK: StyledNavigationBar
    
    override func customizeNavBarStyle() {
        super.customizeNavBarStyle()
        
        DesignStudioElementStyles.pinkNavigationBar(self.navigationController!.navigationBar)
    }
    
    // MARK: - Custom
    
    func addObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "challengeDetailChanged:", name: UITextFieldTextDidEndEditingNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "challengeDetailChanged:", name: UITextViewTextDidEndEditingNotification, object: nil)
    }
    
    func challengeDetailChanged(notification: NSNotification) {
        self.updateData()
    }
    
    func updateData() {
        if self.headerTitle?.text?.length > 0 {
            vm.challengeTitle = self.headerTitle!.text!
        } else {
            vm.challengeTitle = self.headerTitle!.placeholder ?? ""
        }
        if self.headerDescription?.text.length > 0 {
            vm.challengeDescription = self.headerDescription!.text!
        } else {
            vm.challengeDescription = self.headerDescription!.placeholder
        }
    }
    
    // creates table view cell of a specified type
    private func createCell<T: UITableViewCell>(reuseIdentifier: String, indexPath: NSIndexPath, _: T.Type) -> T {
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! T!
        if cell == nil
        {
            cell = T(style: UITableViewCellStyle.Default , reuseIdentifier: reuseIdentifier)
        }
        
        return cell
    }
    
    private func customizeStyle() {
        // remove the separator from the last row; works when we have only one section
        self.tableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 1))
    }
    
    private func prepareViewState() {
        // change the height constraint of the view to show/hide the button
        // so that we don't have empty space when the button is hidden
        self.actionButtonHeightConstraint.constant = 88
        
        if vm.locked {
            self.actionButtonHeightConstraint.constant = 0
        }
        self.addActivityButton.hidden = vm.locked
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destination = segue.destinationViewController as? ActivityDetailViewController
        
        guard destination != nil else {
            return
        }
        
        switch segue.identifier! {
            
        case SegueIdentifier.AddActivity.rawValue:
            destination!.vm.setActivity(vm.getData(nil))
        case SegueIdentifier.EditActivity.rawValue:
            var cell: UITableViewCell?
            if let contentView = sender?.superview {
                cell = contentView?.superview as? UITableViewCell
            }
            
            if cell != nil {
                if let indexPath = self.tableView.indexPathForCell(cell!) {
                    destination!.vm.setActivity(vm.getData(indexPath))
                }
            }
        default:
            destination!.vm.setActivity(vm.getData(nil))
        }
    }
}
