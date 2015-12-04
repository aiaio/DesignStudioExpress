//
//  RunningDesignStudio.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/4/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//
import Foundation

class RunningDesignStudio {
    
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
        }
    }
    
    func startCurrentActivity() {
        if designStudioStartTime == nil {
            designStudioStartTime = NSDate()
        }
    }
}