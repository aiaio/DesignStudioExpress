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
    
    var designStudioTitle: String {
        get { return AppDelegate.designStudio.currentDesignStudio?.title ?? "" }
    }
    
    var challengeTitle: String {
        get { return AppDelegate.designStudio.currentChallenge?.title.uppercaseString ?? "" }
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
                if let notes = AppDelegate.designStudio.currentActivity?.notes {
                    return "\"\(notes)\""
                }
            }
            return ""
        }
    }
    
    var activityNotesEnabled: Bool {
        get {
            if let notes = AppDelegate.designStudio.currentActivity?.notes {
                return notes.length > 0
            }
            return false
        }
    }
    
    var nextButtonText: String {
        if let nextTitle = AppDelegate.designStudio.getNextObjectTitle() {
            return nextTitle.uppercaseString
        } else {
            return ("End " + (AppDelegate.designStudio.currentDesignStudio?.title ?? "")).uppercaseString
        }
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
    
    func skipToNextActivity() {
        AppDelegate.designStudio.skipToNextActivity()
    }
    
    
    func saveImage(image: UIImage) {
        let photoManager = PhotoManager()
        
        photoManager.saveImage(image)
    }
}