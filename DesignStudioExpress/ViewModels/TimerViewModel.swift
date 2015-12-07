//
//  TimerViewModel.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/3/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation
import RealmSwift

class TimerViewModel {
    private var nextObject: Object?
    private var showUpcomingChallengeFlag = false
    private var showEndScreenFlag = false
        
    var currentChallenge: Challenge? {
        get { return AppDelegate.designStudio.currentChallenge }
    }
    
    var challengeTitle: String {
        get { return AppDelegate.designStudio.currentChallenge?.title ?? "" }
    }
    
    var activityTitle: String {
         get { return AppDelegate.designStudio.currentActivity?.title ?? "" }
    }
    
    var currentActivityRemainingDuration: Int {
        get { return AppDelegate.designStudio.currentActivityRemainingDuration }
    }
    
    var activityDescription: String {
        get { return AppDelegate.designStudio.currentActivity?.activityDescription ?? "" }
    }
    
    var activityNotes: String {
        get {
            if self.activityNotesEnabled {
                return "\"\(AppDelegate.designStudio.currentActivity?.notes)\""
            }
            return ""
        }
    }
    
    var activityNotesEnabled: Bool {
        get { return AppDelegate.designStudio.currentActivity?.notes != "" }
    }
    
    // MARK - timer workflow
    
    var segueFromUpcomingChallenge: Bool = false
    
    var showUpcomingChallenge: Bool {
        get {
            return self.showUpcomingChallengeFlag
        }
    }
    
    var showEndScreen: Bool {
        get { return self.showEndScreenFlag }
    }
    
    func timerDidLoad() {
        // if we're coming from a challenge go to next step to load data for the activity
        // we don't want to kick this off on the challenge screen
        // because the animation will skew the clock for the activity
        if self.segueFromUpcomingChallenge {
            self.goToNextStep()
        }
    }
    
    // TODO: comment the logic for this function
    func goToNextStep() {
        self.nextObject = AppDelegate.designStudio.getNextObject()
        
        // go to next activity
        if nextObject is Activity {
            // start the timer on the activity immediately
            AppDelegate.designStudio.startCurrentActivity()
        } else if nextObject is Challenge {
            self.showUpcomingChallengeFlag = true
        } else {
            // there's no next challenge; we've reached the end
            self.showEndScreenFlag = true
        }
    }
}