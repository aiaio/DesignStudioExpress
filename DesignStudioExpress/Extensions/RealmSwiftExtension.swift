//
//  RealmSwiftExtension.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/16/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation
import RealmSwift

extension Results {
    // converts the Results object to an array 
    func toArray<T>(ofType: T.Type) -> [T] {
        return (0..<self.count).flatMap { self[$0] as? T }
    }
}