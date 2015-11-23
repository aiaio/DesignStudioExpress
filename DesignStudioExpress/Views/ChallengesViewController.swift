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
    @IBOutlet weak var addChallengeView: UIView!
    @IBOutlet weak var tableViewParentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let vm = ChallengesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = vm.getDesignStudioTitle()
        
        // show the edit button for reordering of the rows
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.showView()
        tableView.reloadData()
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        // Toggles the edit button state
        super.setEditing(editing, animated: animated)
        // Toggles the actual editing actions appearing on a table view
        tableView.setEditing(editing, animated: true)
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return vm.getTotalRows()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.row == vm.getTotalRows() - 1 {
            let cell = self.createCell("addButtonCell", indexPath: indexPath, UITableViewCell.self)
            
            // hide separator
            cell.separatorInset = UIEdgeInsetsMake(0, self.view.frame.width, 0, 0);
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
        if indexPath.row == vm.getTotalRows() - 1 {
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
            return vm.isRowEditable(indexPath)
        }
        
        return false
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, tappedButtonAtIndex index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        if let indexPath = self.tableView.indexPathForCell(cell) {
            if vm.deleteChallenge(indexPath) {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
        
        return true
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, swipeButtonsForDirection direction: MGSwipeDirection, swipeSettings: MGSwipeSettings!, expansionSettings: MGSwipeExpansionSettings!) -> [AnyObject]! {
        let indexPath = tableView?.indexPathForCell(cell)
        guard indexPath != nil else {
            // cell is not visible
            return []
        }
        
        if direction == .LeftToRight {
            let button = MGSwipeButton(title: "Delete", backgroundColor: DesignStudioStyles.primaryOrange)
            button.setTitleColor(DesignStudioStyles.white, forState: .Normal)
            return [button]
        }
        return []
    }

    // MARK: - Custom
    
    func showView() {
        if vm.isNewDesignStudio() {
            addChallengeView.hidden = false
            tableViewParentView.hidden = true
        } else {
            addChallengeView.hidden = true
            tableViewParentView.hidden = false
        }
    }
    
    override func customizeNavBarStyle() {
        super.customizeNavBarStyle()
        
        DesignStudioElementStyles.pinkNavigationBar(self.navigationController!.navigationBar)
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destination = segue.destinationViewController as! ChallengeDetailViewController
        
        switch segue.identifier! {
            
        case "AddNewChallenge":
            fallthrough
        case "AddNewChallengeCell":
            destination.vm.setChallenge(vm.getData(nil))
        case "EditChallenge":
            if let indexPath = self.tableView.indexPathForCell(sender as! MGSwipeTableCellChallenge) {
                destination.vm.setChallenge(vm.getData(indexPath))
            }
        default:
            destination.vm.setChallenge(vm.getData(nil))
        }
    }
}