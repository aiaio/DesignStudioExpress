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
    dynamic var dateCreated: NSDate = NSDate()
    
    dynamic var duration: Int = 10
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
