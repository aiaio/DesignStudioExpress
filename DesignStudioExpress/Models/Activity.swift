//
//  Activities.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/20/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation
import RealmSwift

class Activity: Object {
    dynamic var id = NSUUID().UUIDString
    dynamic var title = ""
    dynamic var activityDescription = "" // we can't use just description, because that's an NSObject stored property
    dynamic var duration: Int = 5 // minutes
    dynamic var notes = ""
    dynamic var dateCreated: NSDate = NSDate()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    class func createDefaultActivity() -> Activity {
        let activity = Activity()
        activity.title = "Activity Number One"
        activity.duration = 5
        activity.activityDescription = "Here’s where you describe one step in solving your challenge. Like, \"cardstorm new saving features\", or \"share sketches within mini-groups\"."
        
        return activity
    }
}
