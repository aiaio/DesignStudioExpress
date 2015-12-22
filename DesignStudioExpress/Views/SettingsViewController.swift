//
//  SettingsViewController.swift
//  DesignStudioExpress
//
//  Created by Tim Broder on 12/10/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation
import MGSwipeTableCell


class SettingsViewController: UIViewControllerBase, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let vm = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customizeStyle()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
            let cell = self.createCell("settingsHeader", indexPath: indexPath, UITableViewCell.self)
            return cell
        }
        
        let cell = self.createCell("setttingCell", indexPath: indexPath, UITableViewCellSettings.self)
        
        return cell
    }
    
    // customize row height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // default row height for DS cells
        var rowHeight = 60
        
        // row height for photo
        // dynamically adjust based on the device height
        // should refactor to use autoconstraints
        if indexPath.row == 0 {
            let screenSize = UIScreen.mainScreen().bounds.height
            if screenSize <= 480  { // 4s
                rowHeight = 245
            } else if screenSize <= 568 { // 5
                rowHeight = 260
            } else if screenSize <= 667 { // 6
                rowHeight = 360
            } else { // 6++
                rowHeight = 360
            }
        }
        
        return CGFloat(rowHeight)
    }
    
    @objc func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let action = vm.getAction(indexPath) {
            action(self)
        }
    }
    
    // MARK: - Custom
    
    // creates table view cell of a specified type
    private func createCell<T: UITableViewCell>(reuseIdentifier: String, indexPath: NSIndexPath, _: T.Type) -> T {
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! T!
        if cell == nil {
            cell = T(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        // first cell contains static content
        // skip setting the data
        if indexPath.row == 0 {
            return cell
        }
        
        guard let settingCell = cell as? UITableViewCellSettings else {
            return cell
        }
        
        settingCell.title?.text = vm.getTitle(indexPath)
        
        guard let imagePath = vm.getImageName(indexPath) else {
            return cell
        }
        
        settingCell.icon.image = UIImage(named: imagePath)
        
        return cell
    }
    
    private func customizeStyle() {
        // this in comb. with UIEdgeInsetsZero on layoutMargins for a cell
        // will make the cell separator show from edge to edge
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
}
