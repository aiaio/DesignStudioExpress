//
//  TimerViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/3/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit
import FXLabel
import MZTimerLabel

class TimerViewController: UIViewControllerBase, UpcomingChallengeDelegate {
    
    @IBOutlet weak var challengeTitle: FXLabel!
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var activityDescription: FXLabel!
    @IBOutlet weak var activityNotes: UILabel!
    
    @IBOutlet weak var toggleButton: UIButtonLightBlue!
    @IBOutlet weak var skipToNextActivity: UIButton!
    @IBOutlet weak var timer: MZTimerLabel!
    
    let vm = TimerViewModel()
    var showPresenterNotes = true
    
    let showNotesButtonLabel = "PRESENTER NOTES"
    let showDescriptionButtonLabel = "BACK TO DESCRIPTION"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpTimerLabel()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.populateFields()
        if !vm.isDesignStudioRunning {
            self.vm.startDesignStudio()
            self.showNextChallenge()
        } else {
            self.timer.start()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.timer.pause()
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
    
    // MARK: - UpcomingChallengeDelegate
    
    func upcomingChallengeWillDisappear() {
        // kick-off counting time
        self.vm.startCurrentActivity()
        
        // start timer label
        self.timer.start()
    }
    
    // MARK: - Custom
    
    func setUpTimerLabel() {
        self.timer.timerType = MZTimerLabelTypeTimer
        self.timer.timeFormat = "mm:ss"
    }
    
    func populateFields () {
        self.challengeTitle.text = vm.challengeTitle
        self.activityTitle.text = vm.activityTitle
        self.activityDescription.text = vm.activityDescription
        self.activityNotes.text = vm.activityNotes
        
        self.timer.setCountDownTime(Double(vm.currentActivityRemainingDuration))
    }
    
    // toggles between showing notes and description labels
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
    
    func showNextChallenge() {
        if let currentChallenge = vm.currentChallenge {
            if let upcomingChallengeView = self.storyboard?.instantiateViewControllerWithIdentifier("UpcomingChallenges") as? UpcomingChallengeViewController {
                upcomingChallengeView.vm.setChallenge(currentChallenge)
                upcomingChallengeView.delegate = self
                
                self.presentViewController(upcomingChallengeView, animated: true, completion: nil)
            }
        }
    }
    
    func showEndScreen() {
        // TODO
    }
}
