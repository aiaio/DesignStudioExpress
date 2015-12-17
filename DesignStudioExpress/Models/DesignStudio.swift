//
//  DesignStudio.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/14/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation
import RealmSwift

class DesignStudio: Object {
    dynamic var id = NSUUID().UUIDString
    dynamic var title = ""
    dynamic var dateCreated: NSDate = NSDate()
    dynamic var started = false
    dynamic var finished = false
    dynamic var currentChallengeId: String = ""
    dynamic var currentActivityId: String = ""
    
    let challenges = List<Challenge>()
    
    // minutes
    var duration: Int {
        get {
            var duration = 0
            for challenge in self.challenges {
                duration += challenge.duration
            }
            return duration
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    class func createDefaultTemplate1() {
        let realm = try! Realm()
        
        realm.beginWrite()
        
        let ds = DesignStudio()
        ds.title = "New Project Concept"
        realm.add(ds)
        
       
        let challenge = Challenge()
        challenge.title = "Individual Sketching, Group Discussion"
        challenge.challengeDescription  = ""
        
        let activity1 = Activity()
        activity1.title = "Cardstorming"
        activity1.activityDescription = ""
        activity1.notes = ""
        activity1.duration = 1
        challenge.activities.append(activity1)
        
        let activity2 = Activity()
        activity2.title = "Draw 5 ideas in 5 minutes"
        activity2.activityDescription = ""
        activity2.notes = ""
        activity2.duration = 1
        challenge.activities.append(activity2)
        
        let activity3 = Activity()
        activity3.title = "Share sketches within mini groups"
        activity3.activityDescription = ""
        activity3.notes = ""
        activity3.duration = 1
        challenge.activities.append(activity3)
        
        let activity4 = Activity()
        activity4.title = "Sketch"
        activity4.activityDescription = ""
        activity4.notes = ""
        activity4.duration = 1
        challenge.activities.append(activity4)
        
        let activity5 = Activity()
        activity5.title = "Share in mini groups and prepare to present"
        activity5.activityDescription = ""
        activity5.notes = ""
        activity5.duration = 1
        challenge.activities.append(activity5)
        
        let activity6 = Activity()
        activity6.title = "Share and discuss"
        activity6.activityDescription = ""
        activity6.notes = ""
        activity6.duration = 1
        challenge.activities.append(activity6)
        
        let activity7 = Activity()
        activity7.title = "Break"
        activity7.activityDescription = ""
        activity7.notes = ""
        activity7.duration = 1
        challenge.activities.append(activity7)
        
        ds.challenges.append(challenge)
        
        realm.add(ds)
        
        do {
            try realm.commitWrite()
        } catch {
            // TODO handler error
        }
    }
}