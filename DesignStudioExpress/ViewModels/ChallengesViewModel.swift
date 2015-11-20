//
//  ChallengesViewModel.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/19/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation
import RealmSwift

class ChallengesViewModel {
    
    lazy var realm = try! Realm()
    private var data: DesignStudio?
    private var isNew = false
    
    func setDesignStudio(designStudio: DesignStudio) {
        self.data = designStudio
    }
}
