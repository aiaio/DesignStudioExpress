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
    
    func setActivity(newActivity: Activity) {
        self.data = newActivity
    }
    
    var title: String {
        get {
            return self.data.title
        }
        set {
            try! self.realm.write {
                self.data.title = newValue
            }
        }
    }
    
    var duration: String {
        get {
            return "\(data.duration)"
        }
        set {
            try! realm.write {
            self.data.duration = Int(newValue) ?? 0
            }
        }
    }
    
    var description: String {
        get {
            return "\(data.activityDescription)"
        }
        set {
            try! realm.write {
                self.data.activityDescription = newValue
            }
        }
    }
    
    var notes: String {
        get {
            return "\(data.notes)"
        }
        set {
            try! realm.write {
                self.data.notes = newValue
            }
        }
    }
    
}

