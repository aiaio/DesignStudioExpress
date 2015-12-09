//
//  UpcomingChallengeViewModel.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/3/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation

class UpcomingChallengeViewModel {
    
    private var data: Challenge? {
        get { return AppDelegate.designStudio.currentChallenge }
    }
    
    var title: String {
        get { return self.data?.title ?? "" }
    }
    
    var duration: String {
        get { return self.data?.duration != nil ? "Duration: \(self.data!.duration) min" : "" }
    }
    
    var challengeCount: String {
        get {
            let currentChallenges = AppDelegate.designStudio.currentDesignStudio?.challenges
            let totalChallenges = currentChallenges?.count ?? 0
            
            var currentChallengeNumber = 0
                
            if currentChallenges != nil && self.data != nil {
                if let currentChallengeIndex = currentChallenges!.indexOf(self.data!) {
                    currentChallengeNumber = currentChallengeIndex + 1
                }
            }

            return "CHALLENGE \(currentChallengeNumber) OF \(totalChallenges)"
        }
    }
}