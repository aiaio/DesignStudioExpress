//
//  RunningDesignStudio.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/4/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//
import Foundation
import RealmSwift
import NRSimplePlist

class RunningDesignStudio: NSObject {
    
    lazy var realm = try! Realm()
    
    var currentChallengeIdx: Int? = nil
    var currentActivityIdx: Int? = nil
    var currentActivityStart: NSDate? = nil
    
    enum NotificationIdentifier: String {
        case DesignStudioStarted = "DesignStudioStarted"
        case ActivityEnded = "ActivityEnded"
        case PrepareTimerScreen = "PrepareTimerScreen"
        case ShowNextTimerScreen = "ShowNextTimerScreen"
        case ShowNextChallengeScreen = "ShowNextChallengeScreen"
        case ShowEndDesignStudioScreen = "ShowEndDesignStudioScreen"
        case ShowPostDesignStudioScreen = "ShowPostDesignStudioScreen"
        case UpcomingChallengeDidAppear = "UpcomingChallengeDidAppear"
        case EndDesignStudioDidAppear = "EndDesignStudioDidAppear"
        case AddMoreTimeToCurrentActivity = "AddMoreTimeToCurrentActivity"
    }

    private var data: DesignStudio?
    private var isRunning = false
    private var timer: NSTimer?
    
    // flag controls if we need to move to next object
    // and start the global timer (that shows the End activity screen)
    // we have to move to next activity after:
    // - challenges screen has disappeared
    // - next button is clicked on the Timer screen
    // - next button is clicked on the End activity screen
    var startTimer = false
    
    // currently running design studio
    var currentDesignStudio: DesignStudio? {
        get { return data }
    }
    
    var currentChallenge: Challenge? {
        get {
            if self.currentChallengeIdx != nil {
                return self.data?.challenges[self.currentChallengeIdx!]
            }
            return nil
        }
    }
    
    var currentActivity: Activity? {
        get {
            if self.currentActivityIdx != nil {
                return self.currentChallenge?.activities[self.currentActivityIdx!]
            }
            return nil
        }
    }
    
    // in seconds
    var currentActivityRemainingDuration: Int {
        if let totalDuration = self.currentActivity?.duration {
            let totalDurationSecs = totalDuration * 60
            if self.currentActivityStart == nil {
                return totalDurationSecs
            }
            let totalElapsedSecs = -Int(currentActivityStart!.timeIntervalSinceNow) // totalElapsedSecs are negative
            return totalDurationSecs - totalElapsedSecs
        }
        
        // fallback
        return 0
    }
    
    var isDesignStudioRunning: Bool {
        return self.isRunning
    }
        
    // called when user clicks the main action button on challenges screen
    // we need to open an appropriate screen based on the state of the design studio
    // that can be not started|running|finished
    func challengesScreenActionButton (designStudio: DesignStudio) {
        // start the design studio
        if !self.isRunning && !designStudio.started {
            self.startDesignStudio(designStudio)
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationIdentifier.DesignStudioStarted.rawValue, object: self, userInfo: nil)
        
        // show the Gallery screen if the DS is finished
        } else if designStudio.finished {
            let userInfo = ["DesignStudio":designStudio]
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationIdentifier.ShowPostDesignStudioScreen.rawValue, object: self, userInfo: userInfo)
        // show the timer
        } else {
            // if we're comming from the challenges screen, we just have to show the screen
            // don't get the next object and don't reset/start the timer
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationIdentifier.ShowNextTimerScreen.rawValue, object: self, userInfo: nil)
        }
    }
    
    private func startDesignStudio(designStudio: DesignStudio) {
        self.data = designStudio
        self.isRunning = true
        
        // reset pointers, so that we can start another studio
        self.currentChallengeIdx = nil
        self.currentActivityIdx = nil
        
        // record that we started DS
        do {
            try realm.write {
                self.data?.started = true
            }
        } catch {
            // TODO handle error
        }
        
        // get the challenge, which is the first screen to display
        // don't set the startTimer flag, because we don't want the timer to start until
        // the challenge screen disappears
        self.getNextObject()
    }
    
    // notification that gets called when the global timer for the activity runs out
    // we need to show the End Activity screen
    func notifyEndActivity() {
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationIdentifier.ActivityEnded.rawValue, object: self, userInfo: nil)
    }
    
    // this will be called when the timer screen will appear
    func timerWillAppear() {
        if self.startTimer {
            self.getNextObject()
            self.startTimer = false
        }
    }
    
    func upcomingChallengeDidAppear() {
        if self.currentChallengeIdx == 0 {
            // if we're showing first Upcoming challenge then
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationIdentifier.UpcomingChallengeDidAppear.rawValue, object: self, userInfo: nil)
        }
        self.startTimer = true
    }
    
    func endDesignStudioDidAppear() {
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationIdentifier.EndDesignStudioDidAppear.rawValue, object: self, userInfo: nil)
    }
    
    // this will be called when skip activity is called from the timer screen
    func skipToNextActivity() {
        self.showNextScreen()
    }
    
    // called when next activity is touched on End Activity screen
    func endCurrentActivityViewDidDisappear() {
        // prep the navigation stack
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationIdentifier.PrepareTimerScreen.rawValue, object: self, userInfo: nil)
        self.showNextScreen()
    }
    
    func addMoreTimeViewDidDisappear() {
        guard self.currentActivity != nil else {
            return
        }
        // we have to update the current activity start to be now - set duration, 
        // because we want to add 2 more minutes from the time that user clicks the button,
        // not from the time that we displayed the End activity screen
        // the actual duration of the activity will be longer than initial duration +  mins
        // but the timer will always start from 2 mins, and that's what we want
        let now = NSDate()
        self.currentActivityStart = now.dateByAddingTimeInterval(Double(self.currentActivity!.duration) * -60.0)
        
        // update actual data
        self.addMoreTimeToActivity()
        
        // restart the global timer so that we get End activity screen again
        self.startGlobalTimer()
        
        // refresh the data on Timer view if it's loaded
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationIdentifier.AddMoreTimeToCurrentActivity.rawValue, object: self, userInfo: nil)
    }    
    
    // updates the activity duration in the db
    private func addMoreTimeToActivity() {
        var duration = 0
        do {
            duration = try plistGet("AddMoreTimeMinutes", forPlistNamed: "Settings") as! Int
            
            if duration < 1 {
                duration = 1
            }
        } catch let error {
            // TODO handle errors
            print(error)
            duration = 1
        }
        
        do {
            try realm.write {
                self.currentActivity?.duration += duration // mins
            }
        } catch {
            // TODO handle error
        }
    }
    
    private func showNextScreen() {
        let nextObject = self.whatIsNextObject()
        if nextObject == Activity.self {
            // show the timer screen
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationIdentifier.ShowNextTimerScreen.rawValue, object: self, userInfo: nil)
            // don't move to next object immediately, instead set a flag that will move to next object and kick off timer when the timer screen is loaded
            self.startTimer = true
        } else if nextObject == Challenge.self {
            // move to next object immediately, we don't have to worry about timers when displaying Challenges
            self.getNextObject()
            // show the challenge screen
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationIdentifier.ShowNextChallengeScreen.rawValue, object: self, userInfo: nil)
        } else {
            self.finishDesignStudio()
            // we've reached the end, show the end screen
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationIdentifier.ShowEndDesignStudioScreen.rawValue, object: self, userInfo: nil)
        }
    }   
    
    // it's not private because we have to use it on app exit
    func finishDesignStudio() {
        // don't forget to stop the timer at the end
        // we don't want any more popups
        self.timer?.invalidate()
        
        // mark design studio as finished
        do {
            try realm.write {
                self.data?.finished = true
            }
            self.isRunning = false
        } catch {
            // todo
        }
    }
    
    // helper function for determining what will be the next object, 
    // so we can determine screen flow
    private func whatIsNextObject() -> Object.Type? {
        if self.currentChallenge != nil && self.getNextActivityIdx() != nil {
            return Activity.self
        }
        
        if self.getNextChallengeIdx() != nil {
            return Challenge.self
        }
        
        return nil
    }
    
    // this will return either Challenge or Activity or nil, depending on the what's next to show
    // Challenge is always first, then all the activities in that challenge
    // then we repeat the process for next Challenge
    // if the next object is activity the timer will be automatically started
    private func getNextObject() -> Object? {
        
        // try to get next activity in the current challenge
        if self.currentChallengeIdx != nil && self.moveToNextActivity() {
            return self.currentActivity
        }
        
        // try to get next challenge
        if self.moveToNextChallenge() {
            return self.currentChallenge
        }
        
        return nil
    }
    
    
    // update the duration of the activity to the actual duration of the activity
    // and status of the activity (finished)
    private func updateCurrentActivity() {
        do {
            if let diff = self.currentActivityStart?.timeIntervalSinceNow {
                let duration = Int(round(-diff / 60)) // convert seconds to minutes
                try realm.write {
                    self.currentActivity?.duration = duration
                    self.currentActivity?.finished = true
                }
            }
        } catch {
            // TODO handle errors
        }
    }
    
    private func moveToNextActivity() -> Bool {        
        self.updateCurrentActivity()
        
        let result = self.moveActivityPointer()
        
        if result {
            self.updateDesignStudioActivityIdx()
        }
        
        self.startCurrentActivity()
        
        return result
    }
    
    private func moveActivityPointer() -> Bool {
        // move the pointer
        if let nextActivityIdx = self.getNextActivityIdx() {
            self.currentActivityIdx = nextActivityIdx
            return true
        }
        self.currentActivityIdx = nil
        return false
    }
    
    private func getNextActivityIdx() -> Int? {
        let nextActivityIdx = self.currentActivityIdx != nil ? self.currentActivityIdx! + 1 : 0
        if self.currentChallenge?.activities.count > nextActivityIdx {
            return nextActivityIdx
        }
        return nil
    }
    
    private func updateDesignStudioActivityIdx() {
        do {
            try realm.write {
                self.data?.currentActivityId = self.currentActivity?.id ?? ""
            }
        } catch {
            // todo
        }
    }
    
    private func startCurrentActivity() {
        // mark the start of the current activity, so we can calculate
        // total duration of the activity
        self.currentActivityStart = NSDate()
        
        self.startGlobalTimer()
    }
    
    // creates a global timer (and cancels any existing ones)
    // that will show notify when activity is ended,
    // so we can show End activity screen from any of the current views we're on
    private func startGlobalTimer() {
        self.timer?.invalidate()
        if let _ = self.currentActivity {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(Double(self.currentActivityRemainingDuration), target: self, selector: "notifyEndActivity", userInfo: nil, repeats: false)
        }
    }
    
    private func moveToNextChallenge() -> Bool {
        self.updateCurrentActivity()
        self.updateCurrentChallenge()
        
        let result = self.moveChallengePointer()
        
        if result {
            self.updateDesignStudioChallengeIdx()
        }
        
        return result
    }
    
    private func updateCurrentChallenge() {
        do {
            try realm.write {
                self.currentChallenge?.finished = true
            }
        } catch {
            // TODO handle errors
        }
    }
    
    private func updateDesignStudioChallengeIdx() {
        do {
            try realm.write {
                self.data?.currentChallengeId = self.currentChallenge?.id ?? ""
            }
        } catch {
            // todo
        }
    }
    
    private func moveChallengePointer() -> Bool {
        if let nextChallengeIdx = self.getNextChallengeIdx() {
            self.currentChallengeIdx = nextChallengeIdx // move the pointer
            
            // in case that challenge has no activies move to next challenge
            // this shouldn't happen
            if self.currentChallenge?.activities.count == 0 {
                return self.moveToNextChallenge()
            }

            return true
        }
        // there's no more challenges
        return false
    }
    
    func getNextChallengeIdx() -> Int? {
        let nextChallengeIdx = self.currentChallengeIdx != nil ? self.currentChallengeIdx! + 1 : 0
        if self.data?.challenges.count > nextChallengeIdx {
            return nextChallengeIdx
        }
        return nil
    }
    
}