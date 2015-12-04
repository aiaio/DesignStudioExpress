//
//  TimerViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/3/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit
import FXLabel

class TimerViewController: UIViewControllerBase {
    
    @IBOutlet weak var challengeTitle: FXLabel!
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var activityDescription: FXLabel!
    @IBOutlet weak var activityNotes: UILabel!
    
    @IBOutlet weak var toggleButton: UIButtonLightBlue!
    @IBOutlet weak var skipToNextActivity: UIButton!
    
    let vm = TimerViewModel()
    var showPresenterNotes = true
    
    let showNotesButtonLabel = "PRESENTER NOTES"
    let showDescriptionButtonLabel = "BACK TO DESCRIPTION"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showNextChallenge()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
               
        self.populateFields()
    }
    
    @IBAction func switchDescription(sender: AnyObject) {
        self.toggleDescription()
    }
    
    @IBAction func skipToNextActivity(sender: AnyObject) {
        // there's no new activity, skip to next challenge
        if self.vm.moveToNextActivity() {
            // refresh the data
            self.populateFields()
        } else {
            // move to next challenge
            if self.vm.moveToNextChallenge() {
                self.showNextChallenge()
            } else {
                // there's no next challenge; we've reached the end
                self.showEndScreen()
            }
        }
    }
    
    // MARK: StyledNavigationBar
    
    override func customizeNavBarStyle() {
        super.customizeNavBarStyle()
        
        DesignStudioElementStyles.transparentNavigationBar(self.navigationController!.navigationBar)
    }
    
    func populateFields () {
        self.challengeTitle.text = vm.challengeTitle
        self.activityTitle.text = vm.activityTitle
        self.activityDescription.text = vm.activityDescription
        self.activityNotes.text = vm.activityNotes
    }
    
    func toggleDescription() {
        if showPresenterNotes {
            self.toggleButton.setTitle(self.showDescriptionButtonLabel, forState: .Normal)
            self.activityNotes.hidden = false
            self.activityDescription.hidden = true
            self.showPresenterNotes = false
        } else {
            self.toggleButton.setTitle(self.showNotesButtonLabel, forState: .Normal)
            self.activityNotes.hidden = true
            self.activityDescription.hidden = false
            self.showPresenterNotes = true
        }
    }
    
    // MARK: - Custom
    
    func showNextChallenge() {
        if let currentChallenge = vm.currentChallenge {
            if let upcomingChallengeView = self.storyboard?.instantiateViewControllerWithIdentifier("UpcomingChallenges") as? UpcomingChallengeViewController {
                upcomingChallengeView.vm.setChallenge(currentChallenge)
                
                self.presentViewController(upcomingChallengeView, animated: true, completion: { () -> Void in
                    self.vm.startCurrentActivity()
                })
            }
        }
    }
    
    func showEndScreen() {
        // TODO
    }
}
