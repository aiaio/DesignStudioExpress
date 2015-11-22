//
//  ChallengeDetailViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/21/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class ChallengeDetailViewController: UIViewControllerBase, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addActivityButton: UIButtonRed!

    let vm = ChallengeDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // show the edit button for reordering of the rows
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // set the title
        self.navigationItem.title = vm.challengeTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
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
        return vm.getTotalRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.row == 0 {
            let cell = self.createCell("headerCell", indexPath: indexPath, UITableViewCellChallengeHeader.self)
            
            cell.title.text = vm.challengeTitle
            cell.challengeDescription.text = vm.challengeDescription
            cell.duration.text = vm.challengeDuration
            // hide separator
            cell.separatorInset = UIEdgeInsetsMake(0, self.view.frame.width, 0, 0);
            return cell
        }
        
        return UITableViewCell(style: .Default, reuseIdentifier: "bla")
      /*
        let cell = self.createCell("challengeCell", indexPath: indexPath, MGSwipeTableCellChallenge.self)
        cell.delegate = self
        cell.challengeName.text = vm.getTitle(indexPath)
        cell.activitiesLabel.text = vm.getActivities(indexPath)
        cell.duration.text = vm.getDuration(indexPath)
        
        // set separator from edge to edge
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell*/
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        }
        return 195
    }
    
    // MARK: - Custom
    
    override func customizeNavBarStyle() {
        super.customizeNavBarStyle()
        
        DesignStudioElementStyles.pinkNavigationBar(self.navigationController!.navigationBar)
    }
    
    // creates table view cell of a specified type
    private func createCell<T: UITableViewCell>(reuseIdentifier: String, indexPath: NSIndexPath, _: T.Type) -> T {
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! T!
        if cell == nil
        {
            cell = T(style: UITableViewCellStyle.Default , reuseIdentifier: reuseIdentifier)
        }
        
        return cell
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
