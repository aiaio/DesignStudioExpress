//
//  ActivityDetailViewModel.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/1/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import RealmSwift

class ActivityDetailViewModel {
    
    lazy var realm = try! Realm()
    private var data: Activity!
    
    let saveActivityLabelText = "SAVE ACTIVITY"
    let saveNotesLabelText = "SAVE NOTES"
    let backLabelText = "CLOSE"
    
    let saveErrorMsg = "Couldn't save the activity: "
    let deleteErrorMsg = "Couldn't delete the activity"

    var title: String = ""
    var duration: Int = 0
    var description: String = ""
    var notes: String = ""
    
    var editingEnabled: Bool {
        get {
            return !self.data.finished
                && self.data.id != AppDelegate.designStudio.currentActivity?.id
                && !self.locked
        }
    }
    
    // we're using this flag when loading/showing templates
    // which are locked for editing
    var locked: Bool {
        return self.data.challenge.designStudio.template
    }
    
    var saveActivityLabel: String {
        get {
            if self.editingEnabled {
                return self.saveActivityLabelText
            } else if self.locked {
                return self.backLabelText
            }else {
                return self.saveNotesLabelText
            }
        }
    }
    
    func setActivity(newActivity: Activity) {
        self.loadActivity(newActivity)
    }
    
    func loadActivity(newActivity: Activity) {
        self.data = newActivity
        self.title = newActivity.title
        self.duration = newActivity.duration
        self.description = newActivity.activityDescription
        self.notes = newActivity.notes
    }
    
    func saveActivity() -> String? {
        if self.locked {
            return nil
        }
        do {
            try realm.write {
                // we can update only notes when editing is disabled
                if self.editingEnabled {
                    self.data.title = self.title
                    self.data.duration = self.duration
                    self.data.activityDescription = self.description
                }
                self.data.notes = self.notes
                self.realm.add(self.data, update: true)
            }
        } catch let error as NSError {
            print(self.saveErrorMsg + error.localizedDescription)
            return self.saveErrorMsg
        }
        return nil
    }
    
    func deleteActivity() -> String? {
        do {
            try realm.write {
                self.realm.delete(self.data)
            }
        } catch let error as NSError {
            print(self.deleteErrorMsg + error.localizedDescription)
            return self.deleteErrorMsg
        }
        return nil
    }
}

