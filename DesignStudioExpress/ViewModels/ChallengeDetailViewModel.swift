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
        self.data = newChallenge
    }
    
    var getTotalRows: Int {
        get {
            // first cell is a header cell
            return self.data.activities.count + 1
        }
    }
    
    var challengeTitle: String {
        get {
            return self.data!.title
        }
        set {
            // TODO
        }
    }
    
    var challengeDescription: String {
        get {
            return data!.challengeDescription
        }
        set {
            //TODO
        }
    }

    var challengeDuration: String {
        get {
            return "Duration: \(data!.duration) min"
        }
    }
}