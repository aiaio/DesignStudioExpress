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
        
        
    }
    
    private func customizeStyle() {
        // make navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor() // TODO: change this
        self.navigationController?.navigationBar.shadowImage = UIImage()

        // style the button
        self.createButton.setTitleColor(DesignStudioStyles.headerTextLightBG, forState: .Normal)
        self.createButton.backgroundColor = DesignStudioStyles.white
        self.createButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 22)
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.row == 0 {
            let reuseIdentifier = "photoCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as UITableViewCell!
            if cell == nil
            {
                cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
            }
            let img = UIImage(named: "Cell_Test")?.stretchableImageWithLeftCapWidth(0, topCapHeight: 5)
            let iv = UIImageView(image: img)
            cell.backgroundView = iv
            
            return cell
        }
        
        let reuseIdentifier = "swipeCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! MGSwiteTableCellCentered!
        if cell == nil
        {
            cell = MGSwiteTableCellCentered(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        cell.textLabel!.text = vm.getTitle(indexPath)
        cell.detailTextLabel!.text = vm.getDetail(indexPath)
        cell.delegate = self //optional
        
        // alignt labels
        cell.textLabel!.textAlignment = NSTextAlignment.Center
        cell.detailTextLabel!.textAlignment = .Center
        return cell
        
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
        }
        return [MGSwipeButton(title: "Delete", backgroundColor: UIColor.grayColor())]
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
