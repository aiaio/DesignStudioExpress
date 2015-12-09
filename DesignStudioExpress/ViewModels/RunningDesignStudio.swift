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
    }
    
    private let addMoreMinutesDuration = 2 // how many minutes should we add from End activity screen
    
    private var data: DesignStudio?
    private var isRunning = false
    private var timer: NSTimer?
    
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
        // TODO REMOVE THIS!!!!!!
        return 5
        
        if self.currentActivityStart != nil {
            if let totalDuration = self.currentActivity?.duration {
                let totalDurationSecs = totalDuration * 60
                let totalElapsedSecs = -Int(currentActivityStart!.timeIntervalSinceNow) // totalElapsedSecs are negative
                
                return totalDurationSecs - totalElapsedSecs
            }
        }
        
        if let duration = self.currentActivity?.duration {
            return duration * 60
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
            
            do {
                try realm.write {
                    self.data?.started = true
                }
            } catch {
                // TODO handle error
            }
        }
        
        // to get the challenge, which is the first screen to display
        self.getNextObject()
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationIdentifier.DesignStudioStarted.rawValue, object: self, userInfo: nil)
    }
    
    func notifyEndActivity() {
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationIdentifier.ActivityEnded.rawValue, object: self, userInfo: nil)
    }
    
    func timerDidLoad() {
        self.getNextObject()
    }
    
    // this will be called when skip activity is called from the timer screen
    func skipToNextActivity() {
        self.showNextScreen()
    }
    
    func endCurrentActivity() {
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationIdentifier.PrepareTimerScreen.rawValue, object: self, userInfo: nil)
        self.showNextScreen()
    }
    
    private func showNextScreen() {
        let nextObject = self.getNextObject()
        if nextObject is Activity {
            // show the timer screen
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationIdentifier.ShowNextTimerScreen.rawValue, object: self, userInfo: nil)
        } else if nextObject is Challenge {
            // show the challenge screen
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationIdentifier.ShowNextChallengeScreen.rawValue, object: self, userInfo: nil)
        } else {
            // we've reached the end, show the end screen
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationIdentifier.ShowEndDesignStudioScreen.rawValue, object: self, userInfo: nil)
        }
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
        let nextActivityIdx = self.currentActivityIdx != nil ? self.currentActivityIdx! + 1 : 0
        if self.currentChallenge?.activities.count > nextActivityIdx {
            self.currentActivityIdx = nextActivityIdx
            return true
        }
        // there's no more activities in the challenge
        self.currentActivityIdx = nil
        return false
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
        let nextChallengeIdx = self.currentChallengeIdx != nil ? self.currentChallengeIdx! + 1 : 0
        if self.data?.challenges.count > nextChallengeIdx {
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
    
    // MARK: - Time is up 
    
}