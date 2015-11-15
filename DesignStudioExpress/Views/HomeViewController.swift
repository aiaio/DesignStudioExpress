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
    
    @IBAction func createButtonClick(sender: AnyObject) {
        segueActionTriggered(nil)
    }
    
    let vm = HomeViewModel()
    let editDesignStudioSegue = "EditDesignStudio"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customizeStyle()
    }
    
    private func customizeStyle() {
        // TableView - style separator
        self.tableView.separatorColor = DesignStudioStyles.white
        // this in comb. with UIEdgeInsetsZero on layoutMargins for a cell
        // will make the cell separator show from edge to edge
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        // NavigationBar - make navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor() // TODO: change this
        self.navigationController?.navigationBar.shadowImage = UIImage()

        // CreateButton - style the create button
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
            let cell = self.createCell("photoCell", indexPath: indexPath, UITableViewCellCentered.self)
            
            // set the background image
            let image = UIImage(named: "Cell_Test")
            let imageView = UIImageView(image: image)
            imageView.clipsToBounds = true
            imageView.contentMode = .ScaleAspectFill
            cell.backgroundView = imageView
        
            // style title
            cell.textLabel?.textColor = UIColor.blueColor() // TODO change to #88A7D0
            cell.textLabel?.font = UIFont(name: "Avenir-Heavy", size: 13)
            // TODO add spacing
            
            // style detail
            cell.detailTextLabel?.textColor = DesignStudioStyles.white
            cell.detailTextLabel?.font = UIFont(name: "Avenir-Light", size: 22)
            cell.detailTextLabel?.lineBreakMode = .ByWordWrapping
            cell.detailTextLabel?.numberOfLines = 2
            
            // disable user interactions so we don't have highlighted state
            cell.userInteractionEnabled = false
            
            return cell
        }
        
        let cell = self.createCell("swipeCell", indexPath: indexPath, MGSwiteTableCellCentered.self)
        cell.delegate = self

        // set the icon for the duration lable
        // we have to add an image to the attachment
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "12x12")
        attachment.bounds = CGRectMake(-4, -2, attachment.image!.size.width, attachment.image!.size.height);
        
        // create a attributed string with attachment
        let attributedString = NSAttributedString(attachment: attachment)
        // create mutable string from that so we can add more attributes
        let iconString = NSMutableAttributedString(attributedString: attributedString)
        // add the text to the iconString so that the text is on the right side of the icon
        let durationText = NSMutableAttributedString(string: cell.detailTextLabel!.text!)
        iconString.appendAttributedString(durationText)
        cell.detailTextLabel?.attributedText = iconString
        
        return cell
    }
    
    // customize row height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 300
        }
        return 90
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
        let indexPath = tableView?.indexPathForCell(cell)
        guard indexPath != nil else {
            // cell is not visible
            return []
        } 
        
        if direction == .LeftToRight {
            let button = MGSwipeButton(title: "Delete", backgroundColor: DesignStudioStyles.white)
            button.setTitleColor(DesignStudioStyles.primaryOrange, forState: .Normal)
            return [button]
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
    
    private func segueActionTriggered(indexPath: NSIndexPath?) {
        let data = vm.getData(indexPath)
        self.performSegueWithIdentifier(self.editDesignStudioSegue, sender: data)
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
        
        // align labels
        cell.textLabel!.textAlignment = .Center
        cell.detailTextLabel!.textAlignment = .Center
        
        // this in comb. with UIEdgeInsetsZero on layoutMargins for a tableView
        // will make the cell separator show from edge to edge
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
}
