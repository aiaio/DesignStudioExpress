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
    dynamic var duration: Int = 60 // minutes
    
    override static func primaryKey() -> String? {
        return "id"
    }
}