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
}