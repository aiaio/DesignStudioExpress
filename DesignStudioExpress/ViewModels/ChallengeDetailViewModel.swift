//
//  ChallengeDetailViewModel.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/21/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation
import RealmSwift

class ChallengeDetailViewModel {
    
    lazy var realm = try! Realm()
    private var data: Challenge!
        
    func setChallenge(newChallenge: Challenge) {
        self.data = newChallenge
    }
    
    var getTotalRows: Int {
        get {
            // first cell is a header cell
            return self.data.activities.count + 1
        }
    }
    
    var designStudioTitle: String {
        get {
            return self.data.designStudio.title
        }
    }
    
    var challengeTitle: String {
        get {
            return self.data!.title
        }
        set {
            try! realm.write {
                self.data.title = newValue
            }
        }
    }
    
    var challengeDescription: String {
        get {
            return data!.challengeDescription
        }
        set {
            try! realm.write {
                self.data.challengeDescription = newValue
            }
        }
    }

    var challengeDuration: String {
        get {
            return "Duration: \(data!.duration) min"
        }
    }
    
    var actionButtonText: String {
        get {
            if self.locked {
                return "VIEW"
            }
            return "EDIT"
        }
    }
    
    var editingEnabled: Bool {
        get {
            return !self.data.finished
                && AppDelegate.designStudio.currentChallenge?.id != self.data.id
                && !self.locked
        }
    }
    
    var locked: Bool {
        return self.data.designStudio.template || self.data.designStudio.finished
    }
    
    func isRowEditable(indexPath: NSIndexPath) -> Bool {
        return indexPath.row > 0
    }
    
    func activityTitle(indexPath: NSIndexPath) -> String {
        if self.isRowEditable(indexPath) {
            return data.activities[indexPath.row-1].title
        }
        return ""
    }
    
    func activityDescription(indexPath: NSIndexPath) -> String {
        if self.isRowEditable(indexPath) {
            return data.activities[indexPath.row-1].activityDescription
        }
        return ""
    }
    
    func activityDuration(indexPath: NSIndexPath) -> String {
        if self.isRowEditable(indexPath) {
            let formatter = NSNumberFormatter()
            formatter.minimumIntegerDigits = 2
            
            return formatter.stringFromNumber(data.activities[indexPath.row-1].duration) ?? ""
        }
        return ""
    }
    
    func activityDetails(indexPath: NSIndexPath) -> String {
        if self.isRowEditable(indexPath) {
            if data.activities[indexPath.row-1].notes != "" {
                return "1 presenter note"
            }
            return "0 presenter notes"
        }
        return ""
    }
    
    func getData(indexPath: NSIndexPath?) -> Activity {
        if indexPath != nil && self.isRowEditable(indexPath!) {
            return data.activities[indexPath!.row-1]
        }
        
        let activity = Activity()
        activity.duration = 5
        
        try! realm.write {
            self.data.activities.append(activity)
        }
        
        return activity
    }
}