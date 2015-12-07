//
//  UpcomingChallengeViewControllerViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/3/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit
import FXLabel

class UpcomingChallengeViewController: UIViewControllerBase {
    
    @IBOutlet weak var numOfChallenges: FXLabel!
    @IBOutlet weak var challengeTitle: UILabel!
    @IBOutlet weak var duration: UILabel!

    enum SegueIdentifier: String {
        case ShowTimer = "ShowTimer"
    }
    
    let showDuration = 1.0 // TODO: increase this after testing seconds
    let vm = UpcomingChallengeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vm.upcomingChallengeDidLoad()
        self.populateFields()
        self.hideViewAfterTimeout()
    }
        
    func populateFields() {
        self.numOfChallenges.text = self.vm.challengeCount
        self.challengeTitle.text = self.vm.title
        self.duration.text = self.vm.duration
    }
    
    func hideViewAfterTimeout() {
        NSTimer.scheduledTimerWithTimeInterval(showDuration, target: self, selector: "hideView", userInfo: nil, repeats: false)
    }
    
    func hideView() {
        self.performSegueWithIdentifier(SegueIdentifier.ShowTimer.rawValue, sender: self)
    }
    
    // MARK: StyledNavigationBar
    
    override func customizeNavBarStyle() {
        super.customizeNavBarStyle()
        
        DesignStudioElementStyles.transparentNavigationBar(self.navigationController!.navigationBar)
        // don't allow going back to the timer screen
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    // MARK - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.ShowTimer.rawValue {
            if let destination = segue.destinationViewController as? TimerViewController {
                destination.vm.segueFromUpcomingChallenge = true
            }
        }
    }
}
