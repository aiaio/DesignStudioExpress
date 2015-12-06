//
//  RunningDesignStudio.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/4/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//
import Foundation
import RealmSwift

class RunningDesignStudio {
    
    lazy var realm = try! Realm()
    
    var currentChallengeIdx: Int? = nil
    var currentActivityIdx: Int? = nil
    var currentActivityStart: NSDate? = nil
    
    private var data: DesignStudio?
    private var isRunning = false
    
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
            
            do {
                try realm.write {
                    self.data?.started = true
                }
            } catch {
                // TODO handle error
            }
        }
    }
    
    func startCurrentActivity() {
        currentActivityStart = NSDate()
    }
    
    func getNextObject() -> Object? {
        // if the DS has just started, first object to show is
        // a challenge
        if self.currentChallengeIdx == nil {
            self.currentChallengeIdx = 0
            return self.currentChallenge
        }
        
        // if challenge has been just showed
        // show the first activity in that challenge
        if self.currentActivityIdx == nil {
            self.currentActivityIdx = 0
            return self.currentActivity
        }
        
        // try to get next activity in the current challenge
        if self.moveToNextActivity() {
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
        
        // move the pointer
        let nextActivityIdx = self.currentActivityIdx! + 1
        if self.currentChallenge?.activities.count > nextActivityIdx {
            self.currentActivityIdx = nextActivityIdx
            return true
        }
        self.currentActivityIdx = nil
        // there's no more activities in the challenge
        return false
    }
    
    private func moveToNextChallenge() -> Bool {
        self.updateCurrentActivityTime()
        
        let nextChallengeIdx = self.currentChallengeIdx! + 1
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
}