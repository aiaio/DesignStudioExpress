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
    
    var data: DesignStudio?
    var isRunning = false
    var currentChallengeIdx = 0
    var currentActivityIdx = 0
    var designStudioStartTime: NSDate?
    
    
    var currentChallenge: Challenge? {
        get { return self.data?.challenges[self.currentChallengeIdx] }
    }
    
    var currentActivity: Activity? {
        get { return self.currentChallenge?.activities[self.currentActivityIdx] }
    }
    
    func isDesignStudioRunning() -> Bool {
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
        if designStudioStartTime == nil {
            designStudioStartTime = NSDate()
        }
    }
    
    func moveToNextActivity() -> Bool {
        let nextActivityIdx = self.currentActivityIdx + 1
        if self.currentChallenge?.activities.count > nextActivityIdx {
            self.currentActivityIdx = nextActivityIdx
            // TODO - update time???
            
            return true
        }
        // there's no more activities in the challenge
        return false
    }
    
    func moveToNextChallenge() -> Bool {
        let nextChallengeIdx = self.currentChallengeIdx + 1
        if self.data?.challenges.count > nextChallengeIdx {
            self.currentActivityIdx = 0 // reset the activity counter
            self.currentChallengeIdx = nextChallengeIdx
            
            return true
        }
        // there's no more challenges
        return false
    }
}