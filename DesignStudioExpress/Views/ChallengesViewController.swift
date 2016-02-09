//
//  ChallengesViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/18/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class ChallengesViewController: UIViewControllerBase, UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate {
    enum SegueIdentifier: String {
        case AddNewChallenge = "AddNewChallenge"
        case AddNewChallengeCell = "AddNewChallengeCell"
        case EditChallenge = "EditChallenge"
    }
    
    let confirmDeletionTitleText = "You sure?"
    let confirmDeletionMessage = "Deleting this challenge cannot be undone."
    let cannotDeleteChallengeTitleText = "Not right now"
    let cannotDeleteChallengeMessage = "Active challenges cannot be deleted. Finish this Design Studio first, then you can delete."
    
    let errorMessageForActionButtonTitle = "Whoa!"
    
    @IBOutlet weak var addChallengeView: UIView!
    @IBOutlet weak var tableViewParentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var beginDesignStudio: UIButtonRed!
    @IBOutlet weak var actionButtonHeightConstraint: NSLayoutConstraint!
    
    let vm = ChallengesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = vm.designStudioTitle
        
        self.customizeStyle()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareViewState()
        tableView.reloadData()
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        // Toggles the edit button state
        super.setEditing(editing, animated: animated)
        // Toggles the actual editing actions appearing on a table view
        tableView.setEditing(editing, animated: true)
    }
    
    // universal action button that
    @IBAction func actionButton(sender: AnyObject) {
        if let errorMessage = self.vm.actionButtonTouched() {
            self.showWarningAlert(self.errorMessageForActionButtonTitle, message: errorMessage)
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return vm.totalRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.row == vm.totalRows - 1 {
            let cell = self.createCell("addButtonCell", indexPath: indexPath, UITableViewCell.self) as! UITableViewCellAddChallenge
            cell.addChallenge.hidden = !vm.editingEnabled
            
            return cell
        }
        
        let cell = self.createCell("challengeCell", indexPath: indexPath, MGSwipeTableCellChallenge.self)
        cell.delegate = self
        cell.challengeName.text = vm.getTitle(indexPath)
        cell.activitiesLabel.text = vm.getActivities(indexPath)
        cell.duration.text = vm.getDuration(indexPath)
        
        // set separator from edge to edge
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == vm.totalRows - 1 {
            return 75
        }
        return 110
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        vm.reorderRows(sourceIndexPath, destinationRow: destinationIndexPath)
    }
        
    // Conditional rearranging of the table view.
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return vm.isRowEditable(indexPath)
    }
    
    func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        if vm.isRowEditable(proposedDestinationIndexPath) {
            return proposedDestinationIndexPath
        }
        return sourceIndexPath
    }
    
    // Don't show delete/insert controls when editing
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    // Don't indent rows when editing
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    // MARK: - MGSwipeTableCellDelegate
    
    /**
     * Delegate method to enable/disable swipe gestures
     * @return true if swipe is allowed
     **/
    func swipeTableCell(cell: MGSwipeTableCell!, canSwipe direction: MGSwipeDirection) -> Bool {
        if let indexPath = self.tableView.indexPathForCell(cell) {
            return vm.isRowEditable(indexPath) && !vm.locked
        }
        
        return false
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, tappedButtonAtIndex index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        guard let indexPath = self.tableView.indexPathForCell(cell) else {
            return true
        }
        
        if self.vm.canDeleteChallenge(indexPath) {
            let alertController = UIAlertController(title: self.confirmDeletionTitleText, message: self.confirmDeletionMessage, preferredStyle: .Alert)
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
                // try to delete it and remove the row only if we succesfully deleted the challenge
                if self.vm.deleteChallenge(indexPath) {
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    
                    self.prepareViewState()
                }
            })
            alertController.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            self.showWarningAlert(self.cannotDeleteChallengeTitleText, message: self.cannotDeleteChallengeMessage)
            return true
        }
        
        return true
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, swipeButtonsForDirection direction: MGSwipeDirection, swipeSettings: MGSwipeSettings!, expansionSettings: MGSwipeExpansionSettings!) -> [AnyObject]! {
        let indexPath = tableView?.indexPathForCell(cell)
        guard indexPath != nil else {
            // cell is not visible
            return []
        }
        
        if direction == .RightToLeft {
            return [DesignStudioElementStyles.swipeDeleteButtonRed()]
        }
        return []
    }
    
    // MARK: StyledNavigationBar
    
    override func customizeNavBarStyle() {
        super.customizeNavBarStyle()
        
        DesignStudioElementStyles.pinkNavigationBar(self.navigationController!.navigationBar)
    }

    // MARK: - Custom
    
    // Shows the Add New Challenge View, if DS is new
    func prepareViewState() {
        if vm.isNewDesignStudio {
            self.addChallengeView.hidden = false
            self.tableViewParentView.hidden = true
            // hide reordering rows button; the tableview is hidden
            self.navigationItem.rightBarButtonItem = nil
        } else {
            self.addChallengeView.hidden = true
            self.tableViewParentView.hidden = false
            if vm.editingEnabled {
                // show the edit button for reordering of the rows
                self.navigationItem.rightBarButtonItem = self.editButtonItem()
            } else {
                self.navigationItem.rightBarButtonItem = nil
            }
        }
        
        // set the state/height/text of the action button (begin/view/timer button)
        self.beginDesignStudio.enabled = self.vm.beginDesignStudioButtonEnabled
        self.beginDesignStudio.setTitle(self.vm.beginDesignStudioButtonText, forState: .Normal)
        
        self.beginDesignStudio.hidden = self.vm.locked
        // if the button is hidden, hide the parent view, so that the table
        // takes the full height of the container
        self.actionButtonHeightConstraint.constant = 88
        if vm.locked {
            self.actionButtonHeightConstraint.constant = 0
        }
    }
    
    func customizeStyle() {
        // remove the separator from the last row; works when we have only one section
        self.tableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 1))
    }
    
    // creates table view cell of a specified type
    private func createCell<T: UITableViewCell>(reuseIdentifier: String, indexPath: NSIndexPath, _: T.Type) -> T {
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! T!
        if cell == nil
        {
            cell = T(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        }
        
        return cell
    }
    
    private func showWarningAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
            
        case SegueIdentifier.AddNewChallenge.rawValue:
            fallthrough
        case SegueIdentifier.AddNewChallengeCell.rawValue:
            let destination = segue.destinationViewController as! ChallengeDetailViewController
            destination.vm.setChallenge(vm.getChallengesData(nil))
        case SegueIdentifier.EditChallenge.rawValue:
            if let indexPath = self.tableView.indexPathForCell(sender as! MGSwipeTableCellChallenge) {
                let destination = segue.destinationViewController as! ChallengeDetailViewController
                destination.vm.setChallenge(vm.getChallengesData(indexPath))
            }
        default:
            return
        }
    }
}
