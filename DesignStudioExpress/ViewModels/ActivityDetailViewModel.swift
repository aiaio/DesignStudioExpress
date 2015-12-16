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
    
    var title: String = ""
    var duration: Int = 0
    var description: String = ""
    var notes: String = ""
    
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
    
    func saveActivity() {
        do {
            try realm.write {
                self.data.title = self.title
                self.data.duration = self.duration
                self.data.activityDescription = self.description
                self.data.notes = self.notes
                self.realm.add(self.data, update: true)
            }
        } catch {
            //TODO: handle errors
            print("Couldn't save the activity")
        }
    }
    
    func deleteActivity() {
        do {
            try realm.write {
                self.realm.delete(self.data)
            }
        } catch {
            //TODO: handle errors
            print("Couldn't delete the activity")
        }
    }
}

