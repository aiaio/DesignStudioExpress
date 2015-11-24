//
//  HomeViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/13/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class HomeViewController: UIViewControllerBase, UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButton: UIButton!
    
    let vm = HomeViewModel()
    let editDesignStudioSegue = "EditDesignStudio"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customizeStyle()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        vm.refreshData()
        tableView.reloadData()
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
            let cell = self.createCell("photoCell", indexPath: indexPath, MGSwipeTableCellCentered.self)
            self.stylePhotoCell(cell, indexPath: indexPath)
            return cell
        }
        
        let cell = self.createCell("swipeCell", indexPath: indexPath, MGSwipeTableCellCentered.self)
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
                rowHeight = 280
            } else if screenSize <= 568 { // 5
                rowHeight = 280
            } else if screenSize <= 667 { // 6
                rowHeight = 330
            } else { // 6++
                rowHeight = 360
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
        if let indexPath = self.tableView.indexPathForCell(cell) {
            if vm.swipeButtonClicked(indexPath) {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
        
        return true
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, swipeButtonsForDirection direction: MGSwipeDirection, swipeSettings: MGSwipeSettings!, expansionSettings: MGSwipeExpansionSettings!) -> [AnyObject]! {
        guard tableView?.indexPathForCell(cell) != nil else {
            // cell is not visible
            return []
        } 
        
        if direction == .LeftToRight {
            return [DesignStudioElementStyles.swipeDeleteButton()]
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
        NSNotificationCenter.defaultCenter().postNotificationName("DesignStudioLoaded", object: self, userInfo: notificationData)
    }
    
    // creates table view cell of a specified type
    private func createCell<T: UITableViewCell>(reuseIdentifier: String, indexPath: NSIndexPath, _: T.Type) -> T {
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! T!
        if cell == nil
        {
            cell = T(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        cell.textLabel!.text = vm.getTitle(indexPath)
        cell.detailTextLabel!.text = vm.getDetail(indexPath)
        
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
    }
    
    override func customizeNavBarStyle() {
        super.customizeNavBarStyle()
        
        DesignStudioElementStyles.transparentNavigationBar(self.navigationController!.navigationBar)
    }
    
    func stylePhotoCell(cell: MGSwipeTableCellCentered, indexPath: NSIndexPath) {
        // set the background image
        let image = UIImage(named: vm.getImageName(indexPath))
        let imageView = UIImageView(image: image)
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFill
        cell.backgroundView = imageView
        
        // style title
        // TODO change to constant from DesignStudioStyle
        cell.textLabel?.textColor = UIColor(red:0.53, green:0.65, blue:0.82, alpha:1.0)
        cell.textLabel?.font = UIFont(name: "Avenir-Heavy", size: 14)
        cell.textLabel?.attributedText = NSAttributedString.attributedStringWithSpacing(cell.textLabel!.attributedText!, kerning: 2.5)
        
        // style detail
        cell.detailTextLabel?.textColor = DesignStudioStyles.white
        cell.detailTextLabel?.font = UIFont(name: "Avenir-Light", size: 22)
        cell.detailTextLabel?.lineBreakMode = .ByWordWrapping
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.sizeToFit()
        
        // disable user interactions so we don't have highlighted state
        cell.userInteractionEnabled = false
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
