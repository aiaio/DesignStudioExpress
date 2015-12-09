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

class TimerViewController: UIViewControllerBase, MZTimerLabelDelegate {
    
    @IBOutlet weak var challengeTitle: FXLabel!
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var activityDescription: FXLabel!
    @IBOutlet weak var activityNotes: UILabel!
    
    @IBOutlet weak var toggleButton: UIButtonLightBlue!
    @IBOutlet weak var skipToNextActivity: UIButton!
    @IBOutlet weak var timer: MZTimerLabel!
    
    let vm = TimerViewModel()
    var showPresenterNotes = true
    
    enum SegueIdentifier: String {
        case UpcomingChallenge = "ShowUpcomingChallenge"
        case EndStudio = "ShowEndStudio"
    }
    
    let timerViewControllerIdentifier = "TimerViewController"
    let showNotesButtonLabel = "PRESENTER NOTES"
    let showDescriptionButtonLabel = "BACK TO DESCRIPTION"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vm.timerDidLoad()
        
        self.removeLastViewFromNavigation()
        self.setUpTimerLabel()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.populateFields()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.timer.start()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.timer.pause()
    }
    
    @IBAction func switchDescription(sender: AnyObject) {
        self.toggleDescription()
    }
    
    @IBAction func skipToNextActivity(sender: AnyObject) {
        self.vm.goToNextStep()
        
        if vm.showEndScreen {
            self.showEndScreen()
        } else if vm.showUpcomingChallenge {
            self.showUpcomingChallenge()
        } else {
             self.showNextTimerScreen()
        }       
    }
        
    // MARK: StyledNavigationBar
    
    override func customizeNavBarStyle() {
        super.customizeNavBarStyle()
        
        DesignStudioElementStyles.transparentNavigationBar(self.navigationController!.navigationBar)
    }
    
    // MARK - MZTimerLabelDelegate
    
    func timerLabel(timerLabel: MZTimerLabel!, countingTo time: NSTimeInterval, timertype timerType: MZTimerLabelType) {
        if time < 60 {
            timerLabel.timeLabel.textColor = DesignStudioStyles.primaryOrange
        } else {
            timerLabel.timeLabel.textColor = DesignStudioStyles.white
        }
    }
    
    // MARK: - Custom
    
    func setUpTimerLabel() {
        self.timer.delegate = self
        self.timer.timerType = MZTimerLabelTypeTimer
        self.timer.timeFormat = "mm:ss"
        self.timer.timeLabel.textColor = DesignStudioStyles.white
    }
    
    func populateFields () {
        self.challengeTitle.text = vm.challengeTitle
        self.activityTitle.text = vm.activityTitle
        self.activityDescription.text = vm.activityDescription
        self.activityNotes.text = vm.activityNotes
        
        self.timer.setCountDownTime(Double(vm.currentActivityRemainingDuration))
        self.timer.reset()
    }
    
    // toggles between showing notes and description labels
    func toggleDescription() {
        // hide both buttons when there's no presenter notes
        if !vm.activityNotesEnabled {
            self.activityNotes.hidden = true
            self.activityDescription.hidden = true
        } else if showPresenterNotes {
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
    
    // since we're segueing to the same VC, we need to remove the previous TimerViewController instance
    // so that Back button leads to Challenges screen
    func removeLastViewFromNavigation() {
        let endIndex = (self.navigationController?.viewControllers.endIndex ?? 0) - 1
        if endIndex > 0 {
            let previousVC = self.navigationController?.viewControllers[endIndex-1]
            if previousVC is TimerViewController || previousVC is UpcomingChallengeViewController {
                self.navigationController?.viewControllers.removeAtIndex(endIndex-1)
            }
        }
    }
    
    func showNextTimerScreen() {
        // segue to self
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier(self.timerViewControllerIdentifier) as? TimerViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showUpcomingChallenge() {
        self.performSegueWithIdentifier(SegueIdentifier.UpcomingChallenge.rawValue, sender: self)
    }
        
    func showEndScreen() {
        self.performSegueWithIdentifier(SegueIdentifier.EndStudio.rawValue, sender: self)
    }
}
