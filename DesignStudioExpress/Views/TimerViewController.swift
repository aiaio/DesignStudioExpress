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
import DKCamera
import AVFoundation

class TimerViewController: UIViewControllerBase, MZTimerLabelDelegate {
    
    @IBOutlet weak var challengeTitle: FXLabel!
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var activityDescription: FXLabel!
    @IBOutlet weak var activityNotes: UILabel!
    
    @IBOutlet weak var toggleButton: UIButtonLightBlue!
    @IBOutlet weak var skipToNextActivity: FXLabel!
    @IBOutlet weak var timer: MZTimerLabel!
    
    enum NotificationIdentifier: String {
        case AddMoreTimeToCurrentActivityNotification = "AddMoreTimeToCurrentActivity"
    }
    
    enum ViewControllerIdentifier: String {
        case TimerViewController = "TimerViewController"
    }

    
    let vm = TimerViewModel()
    var showPresenterNotes = true
    
    let showNotesButtonLabel = "PRESENTER NOTES"
    let showDescriptionButtonLabel = "BACK TO DESCRIPTION"
    let cameraAccessErrorTitle = "Camera needs your permission!"
    let cameraAccessErrorMessage = "Open iPhone Settings and tap on Design Studio Express. Allow app to access your camera."

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.removeLastViewFromNavigation()
        self.setUpTimerLabel()
        self.addObservers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        AppDelegate.designStudio.timerWillAppear()
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
        self.vm.skipToNextActivity()
    }
    
    @IBAction func takePicture(sender: AnyObject) {
        if AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) == .Authorized {
            self.showCamera()
        } else {
            self.showWarningAlert(self.cameraAccessErrorTitle, message: self.cameraAccessErrorMessage)
        }
    }
    
    private func showWarningAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func showCamera() {
        let camera = DKCamera()
        
        camera.didCancelled = { () in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        camera.didFinishCapturingImage = {(image: UIImage) in
            self.vm.saveImage(image)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.presentViewController(camera, animated: true, completion: nil)
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
    
    private func addObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshData:",
            name: NotificationIdentifier.AddMoreTimeToCurrentActivityNotification.rawValue, object: nil)
    }
    
    func refreshData(notification: NSNotification) {
        self.populateFields()
        self.timer.start()
    }
    
    // remove
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func setUpTimerLabel() {
        self.timer.delegate = self
        self.timer.timerType = MZTimerLabelTypeTimer
        self.timer.timeFormat = "mm:ss"
        self.timer.timeLabel.textColor = DesignStudioStyles.white
    }
    
    private func populateFields () {
        self.navigationItem.title = vm.designStudioTitle
        self.challengeTitle.text = vm.challengeTitle
        self.activityTitle.text = vm.activityTitle
        self.activityDescription.text = vm.activityDescription
        self.activityNotes.text = vm.activityNotes
        
        self.timer.setCountDownTime(Double(vm.currentActivityRemainingDuration))
        self.timer.reset()
        
        self.skipToNextActivity.text = vm.nextButtonText
        
        // hide/show toggle button for switching between description and presenter notes
        self.toggleButton.hidden = !vm.activityNotesEnabled
    }
    
    // toggles between showing notes and description labels
    private func toggleDescription() {
        if showPresenterNotes {
            // show activity notes
            self.toggleButton.setTitle(self.showDescriptionButtonLabel, forState: .Normal)
            self.activityNotes.hidden = false
            self.activityDescription.hidden = true
            self.showPresenterNotes = false
        } else {
            // show activity description
            self.toggleButton.setTitle(self.showNotesButtonLabel, forState: .Normal)
            self.activityNotes.hidden = true
            self.activityDescription.hidden = false
            self.showPresenterNotes = true
        }
    }
    
    // to make back button always lead to the challenges screen
    // remove all Timers and Upcoming challenge screens from the nav stack
    private func removeLastViewFromNavigation() {
        let endIndex = (self.navigationController?.viewControllers.endIndex ?? 0) - 1
        if endIndex > 0 {
            let previousVC = self.navigationController?.viewControllers[endIndex-1]
            if previousVC is TimerViewController || previousVC is UpcomingChallengeViewController {
                self.navigationController?.viewControllers.removeAtIndex(endIndex-1)
            }
        }
    }
    
    private func showNextTimerScreen() {
        // segue to self
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier(ViewControllerIdentifier.TimerViewController.rawValue) as? TimerViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
