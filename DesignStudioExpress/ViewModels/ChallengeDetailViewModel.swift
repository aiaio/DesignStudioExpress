//
//  ChallengeDetailViewModel.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/21/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation
import RealmSwift

class ChallengeDetailViewModel {
    
    lazy var realm = try! Realm()
    private var data: Challenge!
        
    func setChallenge(newChallenge: Challenge) {
        if data?.id != newChallenge.id {
            self.data = newChallenge
        }
    }
}