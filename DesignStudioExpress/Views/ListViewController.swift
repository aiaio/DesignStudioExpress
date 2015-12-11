//
//  ListTableViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/11/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // download templates
        if indexPath.row == 3 {
            if let path = NSBundle.mainBundle().pathForResource("templates", ofType: "pdf") {
                let data = NSData(contentsOfFile: path)
                let openWithActionView = UIActivityViewController(activityItems: [data!], applicationActivities: nil)
                self.presentViewController(openWithActionView, animated: true, completion: nil)
            }
        }
    }
}
