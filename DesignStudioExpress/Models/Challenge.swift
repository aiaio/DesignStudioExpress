//
//  Challenge.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/20/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation
import RealmSwift

class Challenge: Object {
    dynamic var id = NSUUID().UUIDString
    dynamic var title = ""
    dynamic var challengeDescription = "" // we can't use just description, because that's an NSObject stored property
    dynamic var dateCreated: NSDate = NSDate()
    
    let activities = List<Activity>()
    
    var duration: Int {
        get {
            if self.activities.count == 0 {
                return 0
            }
            return self.activities.sum("duration")
        }
    }
    
    var designStudio: DesignStudio {
        let parentDesignStudio = linkingObjects(DesignStudio.self, forProperty: "challenges")
        
        return parentDesignStudio[0]
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}