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
        if indexPath.row < data.count {
            return true
        }
        
        return false
    }
    
    // handler for Delete button
    // since we have only one swipe button
    func swipeButtonClicked(indexPath: NSIndexPath) -> Bool {
        let idx = indexPath.row
        var success = false
        
        try! self.realm.write {
            self.realm.delete(self.data[idx])
            success = true
        }
        
        return success
    }

    
    func getTitle(indexPath: NSIndexPath) -> String {
        if indexPath.row == getTotalRows() - 1 {
            return ""// TODO?
        }
        return data[indexPath.row].title
    }
    
    func getActivities(indexPath: NSIndexPath) -> String {
        if indexPath.row == getTotalRows() - 1 {
            return ""// TODO?
        }
        return "\(data[indexPath.row].activities.count) Activities"
    }
    
    func getDuration(indexPath: NSIndexPath) -> String {
        if indexPath.row == getTotalRows() - 1 {
            return ""// TODO?
        }
        return "\(data[indexPath.row].duration)"
    }

}
