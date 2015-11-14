//
//  HomeViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/13/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class HomeViewController: BaseUIViewController, UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButton: UIButton!
    
    let vm = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customizeStyle()
        
        // display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    private func customizeStyle() {
        // make navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor() // TODO: change this
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //self.navigationController?.navigationBar.translucent = true
        //self.navigationController?.view.backgroundColor = UIColor.clearColor()
        //self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()

        // style the button
        self.createButton.setTitleColor(DesignStudioStyles.secondaryButtonText, forState: .Normal)
        self.createButton.backgroundColor = DesignStudioStyles.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return vm.getTotalRows()
    }
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row < 2 {
            return false
        }
        return true
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let reuseIdentifier = "programmaticCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! MGSwiteTableCellCentered!
        if cell == nil
        {
            cell = MGSwiteTableCellCentered(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        cell.textLabel!.text = vm.getTitle(indexPath)
        cell.detailTextLabel!.text = vm.getDetail(indexPath)
        cell.delegate = self //optional
        
        cell.textLabel!.textAlignment = NSTextAlignment.Center
        cell.detailTextLabel!.textAlignment = .Center
        
        return cell
    }

    // support rearranging of the rows
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        vm.reorderRows(fromIndexPath, toIndexPath: toIndexPath)
    }
    
    // Override to support conditional rearranging of the table view.
    // Return NO if you do not want the item to be re-orderable.
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return vm.isRowEditable(indexPath)
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
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
        if let indexPath = self.tableView.indexPathForCell(cell) {
            vm.swipeButtonClicked(indexPath)
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
            return [MGSwipeButton(title: "Edit", backgroundColor: UIColor.redColor())]
        } else if direction == .LeftToRight {
            return [MGSwipeButton(title: "Delete", backgroundColor: UIColor.grayColor())]
        }
        
        return []
    }
    
    /*
    // customize cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("photoCell", forIndexPath: indexPath) as UITableViewCell
    
    // Configure the cell...
    let currentPhoto = photos[indexPath.row]
    cell.textLabel?.text = currentPhoto.name
    
    return cell
    }*/
    
    
    
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    photos.removeAtIndex(indexPath.row)
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    
    }
    }*/
    
    /*
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
    if (indexPath.row == photos.count) {
    
    return UITableViewCellEditingStyle.Insert;
    
    } else {
    return UITableViewCellEditingStyle.Delete
    }
    }
    
    // swipable actions
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    let deleteClosure = { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
    print("Delete closure called")
    }
    
    let moreClosure = { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
    print("More closure called")
    }
    
    let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: deleteClosure)
    let moreAction = UITableViewRowAction(style: .Normal, title: "More", handler: moreClosure)
    
    return [deleteAction, moreAction]
    }*/
    
    // Override to support rearranging the table view.
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }   
    
}
