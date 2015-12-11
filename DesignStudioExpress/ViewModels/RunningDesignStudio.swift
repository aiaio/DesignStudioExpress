//
//  RunningDesignStudio.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/4/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//
import Foundation
import RealmSwift

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
        case UpcomingChallengeDidAppear = "UpcomingChallengeDidAppear"
        case AddMoreTimeToCurrentActivity = "AddMoreTimeToCurrentActivity"
    }
    
    private let addMoreMinutesDuration = 2 // how many minutes should we add from End activity screen
    
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
            let totalDurationSecs = totalDuration * 60 // TODO fix this // convert minutes to seconds
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
    
    func startDesignStudio(designStudio: DesignStudio) {
        if !self.isRunning && !designStudio.started {
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
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationIdentifier.DesignStudioStarted.rawValue, object: self, userInfo: nil)
        } else {
            // if we're comming from the challenges screen, we just have to show the screen
            // don't get the next object and don't reset/start the timer
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationIdentifier.ShowNextTimerScreen.rawValue, object: self, userInfo: nil)
        }
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
    
    // called when add more time is touched on End Activity screen
    func addMoreTimeViewDidDisappear() {
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationIdentifier.AddMoreTimeToCurrentActivity.rawValue, object: self, userInfo: nil)
    }    
    
    func addMoreTimeToActivity() {
        do {
            try realm.write {
                self.currentActivity?.duration += self.addMoreMinutesDuration // mins
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
            self.startTimer = true
        } else {
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
    
    private func updateCurrentActivityTime() {
        // update the duration of the activity to the actual duration
        do {
            if let diff = self.currentActivityStart?.timeIntervalSinceNow {
                let duration = Int(round(-diff / 60)) // convert seconds to minutes
                try realm.write {
                    self.currentActivity?.duration = duration
                }
            }
        } catch {
            // TODO handle errors
        }
    }
    
    private func moveToNextActivity() -> Bool {        
        self.updateCurrentActivityTime()
        
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
        self.currentActivityStart = NSDate()
        
        self.timer?.invalidate()
        if let _ = self.currentActivity {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(Double(self.currentActivityRemainingDuration), target: self, selector: "notifyEndActivity", userInfo: nil, repeats: false)
        }
    }
    
    private func moveToNextChallenge() -> Bool {
        self.updateCurrentActivityTime()
        
        let result = self.moveChallengePointer()
        
        if result {
            self.updateDesignStudioChallengeIdx()
        } else {
            self.finishDesignStudio()
        }
        
        return result
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