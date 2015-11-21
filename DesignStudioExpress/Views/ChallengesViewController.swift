//
//  ChallengesViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/18/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class ChallengesViewController: BaseUIViewController, UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate {
    @IBOutlet weak var addChallengeView: UIView!
    @IBOutlet weak var tableViewParentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let vm = ChallengesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showView() {
        if vm.isNewDesignStudio() {
            addChallengeView.hidden = false
            tableViewParentView.hidden = true
        } else {
            addChallengeView.hidden = true
            tableViewParentView.hidden = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.showView()
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
    
    // MARK: - Custom
    
    // creates table view cell of a specified type
    private func createCell<T: UITableViewCell>(reuseIdentifier: String, indexPath: NSIndexPath, _: T.Type) -> T {
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! T!
        if cell == nil
        {
            cell = T(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        }
        
        return cell
    }
    
    override func customizeNavBarStyle() {
        super.customizeNavBarStyle()
        
        DesignStudioElementStyles.pinkNavigationBar(self.navigationController!.navigationBar)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
