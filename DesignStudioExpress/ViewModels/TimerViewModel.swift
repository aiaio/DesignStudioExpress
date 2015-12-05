//
//  TimerViewModel.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/3/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation

class TimerViewModel {
    private var data: DesignStudio?
    
    func setDesignStudio(designStudio: DesignStudio) {
        self.data = designStudio
    }
    
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
    
    var isDesignStudioRunning: Bool {
        get { return AppDelegate.designStudio.isDesignStudioRunning }
    }
    
    func startDesignStudio() {
        if self.data != nil {
            AppDelegate.designStudio.startDesignStudio(self.data!)
        }
    }
    
    func startCurrentActivity() {
        AppDelegate.designStudio.startCurrentActivity()
    }
    
    func moveToNextActivity() -> Bool {
        return AppDelegate.designStudio.moveToNextActivity()
    }
    
    func moveToNextChallenge() -> Bool {
        return AppDelegate.designStudio.moveToNextChallenge()
    }
}