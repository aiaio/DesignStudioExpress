//
//  UpcomingChallengeViewModel.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/3/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation

class UpcomingChallengeViewModel {
    
    var data: Challenge?
    
    func setChallenge(challenge: Challenge) {
        self.data = challenge
    }
    
    var title: String {
        get { return self.data!.title }
    }
    
    var duration: String {
        get { return "Duration: \(self.data!.duration) min" }
    }
    
    var challengeCount: String {
        get {
            let totalChallenges = self.data!.designStudio.challenges.count
            let currentChallenge = self.data!.designStudio.challenges.indexOf(self.data!)! + 1

            return "CHALLENGE \(currentChallenge) OF \(totalChallenges)"
        }
    }
}