//
//  ChallengesViewModel.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/19/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation
import RealmSwift

class ChallengesViewModel {
    
    lazy var realm = try! Realm()
    private var designStudio: DesignStudio!
    private var data: List<Challenge>!
    
    let buttonLabelTimer = "SHOW TIMER"
    let buttonLabelFinished = "STUDIO FINISHED"
    let buttonLabelBeginDS = "BEGIN DESIGN STUDIO"
    let buttonLabelRunning = "RUNNING"
    
    func setDesignStudio(newDesignStudio: DesignStudio) {
        if (self.designStudio?.id != newDesignStudio.id) {
            self.designStudio = newDesignStudio
            self.data = newDesignStudio.challenges
        }
    }
    
    // +1 because the last row is a button
    var totalRows: Int {
        get { return data.count + 1 }
    }
    
    // 'new' ds has no challenges
    var isNewDesignStudio: Bool {
        get { return data.count == 0 }
    }
    
    var isAnotherStudioRunning: Bool {
        get {
            if !AppDelegate.designStudio.isDesignStudioRunning {
                return false
            }
            if let runningDSId = AppDelegate.designStudio.currentDesignStudio?.id {
                return runningDSId != self.designStudio.id
            }
            return false
        }
    }
    
    var beginDesignStudioButtonEnabled: Bool {
        return !isNewDesignStudio && !isAnotherStudioRunning
    }
    
    var beginDesignStudioButtonText: String {
        if self.designStudio.finished {
            return self.buttonLabelFinished
        } else if AppDelegate.designStudio.isDesignStudioRunning {
            if self.isAnotherStudioRunning {
                let runningDSTitle = AppDelegate.designStudio.currentDesignStudio!.title
                return "\(runningDSTitle)" + self.buttonLabelRunning
            } else {
                return self.buttonLabelTimer
            }
        }
        return self.buttonLabelBeginDS
    }
    
    var designStudioTitle: String {
        get { return self.designStudio.title }
    }
    
    var editingEnabled: Bool {
        get { return !self.designStudio.started }
    }
    
    func isRowEditable(indexPath: NSIndexPath) -> Bool {
        return indexPath.row < data.count
    }
    
    func reorderRows(sourceRow: NSIndexPath, destinationRow: NSIndexPath) {
        try! realm.write {
            self.data.move(from: sourceRow.row, to: destinationRow.row)
        }
    }
    
    // handler for Delete button
    func deleteChallenge(indexPath: NSIndexPath) -> Bool {
        let idx = indexPath.row
        var success = false
        
        try! self.realm.write {
            self.realm.delete(self.data[idx])
            success = true
        }
        
        return success
    }
    
    func getTitle(indexPath: NSIndexPath) -> String {
        if self.isRowEditable(indexPath) {
            return data[indexPath.row].title
        }
        return ""
    }
    
    func getActivities(indexPath: NSIndexPath) -> String {
        if self.isRowEditable(indexPath) {
            let activityCount = data[indexPath.row].activities.count
            var activityLabel = "Activities"
            if (activityCount == 1) {
                activityLabel = "Activity"
            }
            return "\(activityCount) \(activityLabel)"
        }
        return ""
    }
    
    func getDuration(indexPath: NSIndexPath) -> String {
        if self.isRowEditable(indexPath) {
            let formatter = NSNumberFormatter()
            formatter.minimumIntegerDigits = 2
            
            return formatter.stringFromNumber(data[indexPath.row].duration) ?? ""
        }
        return ""
    }
    
    func getChallengesData(indexPath: NSIndexPath?) -> Challenge {
        if indexPath != nil && self.isRowEditable(indexPath!) {
            return data[indexPath!.row]
        }
        return createNewChallenge()
    }
    
    func actionButtonTouched() {
        AppDelegate.designStudio.challengesScreenActionButton(self.designStudio)
    }
    
    private func createNewChallenge() -> Challenge {
        let challenge = Challenge()
        let activity = Activity.createDefaultActivity()
        challenge.activities.append(activity)
        
        try! realm.write {
            self.designStudio.challenges.append(challenge)
        }
        
        return challenge
    }

}
