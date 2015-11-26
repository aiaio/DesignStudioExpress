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
    
    func setDesignStudio(newDesignStudio: DesignStudio) {
        if (self.designStudio?.id != newDesignStudio.id) {
            self.designStudio = newDesignStudio
            self.data = newDesignStudio.challenges
        }
    }
    
    // +1 because the last row is a button
    func getTotalRows() -> Int {
        return data.count + 1
    }
    
    func isNewDesignStudio () -> Bool {
        return data.count == 0
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

    func getDesignStudioTitle() -> String {
        return self.designStudio.title
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
            if data[indexPath.row].duration == 0 {
                return "00"
            }
            return "\(data[indexPath.row].duration)"
        }
        return ""
    }
    
    func getData(indexPath: NSIndexPath?) -> Challenge {
        if indexPath != nil && self.isRowEditable(indexPath!) {
            return data[indexPath!.row]
        }
        return createNewChallenge()
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
