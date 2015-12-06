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
    
    private var data: DesignStudio?
    private var isRunning = false
    var currentChallengeIdx = 0
    var currentActivityIdx = 0
    var currentActivityStart: NSDate? = nil
    
    var currentDesignStudio: DesignStudio? {
        get { return data }
    }
    
    var currentChallenge: Challenge? {
        get { return self.data?.challenges[self.currentChallengeIdx] }
    }
    
    var currentActivity: Activity? {
        get { return self.currentChallenge?.activities[self.currentActivityIdx] }
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
        if self.moveToNextActivity() {
            return self.currentActivity
        }
        
        if self.moveToNextChallenge() {
            return self.currentChallenge
        }
        
        return nil
    }
    
    private func moveToNextActivity() -> Bool {
        self.updateCurrentActivityTime()
        
        // move the pointer
        let nextActivityIdx = self.currentActivityIdx + 1
        if self.currentChallenge?.activities.count > nextActivityIdx {
            self.currentActivityIdx = nextActivityIdx
            return true
        }
        // there's no more activities in the challenge
        return false
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
    
    private func moveToNextChallenge() -> Bool {
        self.updateCurrentActivityTime()
        
        let nextChallengeIdx = self.currentChallengeIdx + 1
        if self.data?.challenges.count > nextChallengeIdx {
            self.currentActivityIdx = 0 // reset the activity counter
            self.currentChallengeIdx = nextChallengeIdx // move the pointer
            
            // in case that challenge has no activies move to next challenge
            // this shouldn't happen
            if self.currentChallenge?.activities.count == 0 {
                return self.moveToNextActivity()
            }
            
            return true
        }
        // there's no more challenges
        return false
    }
}