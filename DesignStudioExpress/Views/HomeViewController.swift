//
//  HomeViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/13/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButton: UIButton!
    
    let vm = HomeViewModel()
    let editDesignStudioSegue = "EditDesignStudio"
    
    let confirmDeletionTitleText = "You sure?"
    let confirmDeletionMessage = "Deleting this design studio cannot be undone."
    let cannotDeleteCurrentStudioTitleText = "Not right now"
    let cannotDeleteCurrentStudioMessageText = "This Design Studio is in progress. Skip activities to complete it, then you can delete."
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // customize style of the view here, so that we have correct frame sizes 
        // when we're adding borders etc.
        self.customizeStyle()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        vm.refreshData()
        tableView.reloadData()
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
        if indexPath.row == 0 {
            let cell = self.createCell("photoCell", indexPath: indexPath, UITableViewCell.self)
            //self.stylePhotoCell(cell, indexPath: indexPath)
            return cell
        }
        
        let cell = self.createCell("swipeCell", indexPath: indexPath, MGSwipeTableCellCentered.self)
        cell.textLabel?.text = vm.getTitle(indexPath)
        cell.detailTextLabel?.text = vm.getDetail(indexPath)
        cell.delegate = self
        
        self.styleSwipeCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    // customize row height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // default row height for DS cells
        var rowHeight = 90
        
        // row height for photo
        // dynamically adjust based on the device height
        // should refactor to use autoconstraints
        if indexPath.row == 0 {
            let screenSize = UIScreen.mainScreen().bounds.height
            if screenSize <= 480  { // 4s
                rowHeight = 245
            } else if screenSize <= 568 { // 5
                rowHeight = 245
            } else if screenSize <= 667 { // 6
                rowHeight = 330
            } else { // 6++
                rowHeight = 320
            }
        }
        
        return CGFloat(rowHeight)
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.segueActionTriggered(indexPath)
    }
    
    // MARK - MGSwipeTableCellDelegate
    
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
        guard let indexPath = self.tableView.indexPathForCell(cell) else {
            return true
        }
        
        if self.vm.canDeleteDesignStudio(indexPath) {
            let alertController = UIAlertController(title: self.confirmDeletionTitleText, message: self.confirmDeletionMessage, preferredStyle: .Alert)
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
                // try to delete it and remove the row only if we succesfully deleted design studio
                if self.vm.deleteDesignStudio(indexPath) {
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            })
            alertController.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: self.cannotDeleteCurrentStudioTitleText, message: self.cannotDeleteCurrentStudioMessageText, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        return true
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, swipeButtonsForDirection direction: MGSwipeDirection, swipeSettings: MGSwipeSettings!, expansionSettings: MGSwipeExpansionSettings!) -> [AnyObject]! {
        guard tableView?.indexPathForCell(cell) != nil else {
            // cell is not visible
            return []
        } 
        
        if direction == .RightToLeft {
            return [DesignStudioElementStyles.swipeDeleteButtonWhite()]
        }
        return []
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == self.editDesignStudioSegue {
            let destination = segue.destinationViewController as! DetailDesignStudioViewController
            destination.vm.setDesignStudio(sender as? DesignStudio)
        }
    }
    
    // MARK: - Custom
    
    @IBAction func createButtonClick(sender: AnyObject) {
        segueActionTriggered(nil)
    }
    
    private func segueActionTriggered(indexPath: NSIndexPath?) {
        var notificationData: [NSObject: AnyObject]? = nil
        if let data = vm.getData(indexPath) {
            notificationData = ["DesignStudio":data]
        }
        // raise a notification whe
        NSNotificationCenter.defaultCenter().postNotificationName("DesignStudioLoaded", object: self, userInfo: notificationData)
    }
    
    // creates table view cell of a specified type
    private func createCell<T: UITableViewCell>(reuseIdentifier: String, indexPath: NSIndexPath, _: T.Type) -> T {
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! T!
        if cell == nil
        {
            cell = T(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        return cell
    }
    
    private func customizeStyle() {
        // TableView - style separator
        self.tableView.separatorColor = DesignStudioStyles.white
        // this in comb. with UIEdgeInsetsZero on layoutMargins for a cell
        // will make the cell separator show from edge to edge
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        // CreateButton - style the create button
        self.createButton.setTitleColor(DesignStudioStyles.headerTextLightBG, forState: .Normal)
        self.createButton.backgroundColor = DesignStudioStyles.white
        self.createButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 22)
        
        // Create a border for the button
        let lineView = UIView(frame: CGRectMake(0, 0, self.createButton.frame.size.width , 1))
        lineView.backgroundColor = DesignStudioStyles.bottomNavigationBGColorSelected
        self.createButton.addSubview(lineView)
    }
    
    func styleSwipeCell(cell: MGSwipeTableCellCentered, indexPath: NSIndexPath) {
        // no highlighted color so that we don't have higlighted cell
        // when we go back
        cell.selectionStyle = .None
        
        // background colors for cells
        var cellColor: UIColor?
        if vm.isRowEditable(indexPath) {
            cellColor = DesignStudioStyles.secondaryOrange
        } else {
            cellColor = DesignStudioStyles.primaryOrange
        }
        cell.backgroundColor = cellColor
        
        // set the icon for the duration lable
        // we have to add an image to the attachment
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: vm.getImageName(indexPath))
        // adjust the position of the icon
        attachment.bounds = CGRectMake(-4, -1, attachment.image!.size.width, attachment.image!.size.height);
        
        // create a attributed string with attachment
        let attributedString = NSAttributedString(attachment: attachment)
        // create mutable string from that so we can add more attributes
        let iconString = NSMutableAttributedString(attributedString: attributedString)
        // add the text to the iconString so that the text is on the right side of the icon
        let durationText = NSMutableAttributedString(string: cell.detailTextLabel!.text!)
        iconString.appendAttributedString(durationText)
        cell.detailTextLabel?.attributedText = iconString
        
        // styling for for title
        cell.textLabel?.font = UIFont(name: "Avenir-Book", size: 22)
        cell.textLabel?.textColor = DesignStudioStyles.white
        
        // styling for the detail
        cell.detailTextLabel?.font = UIFont(name: "Avenir-Light", size: 11)
        cell.detailTextLabel?.textColor = DesignStudioStyles.white
        
        // set separator from edge to edge
        cell.layoutMargins = UIEdgeInsetsZero
    }
}
