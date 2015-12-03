//
//  TimerViewModel.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/3/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation

class TimerViewModel {
    
    var data: DesignStudio?
    var currentChallenge = -1
    
    func setDesignStudio(designStudio: DesignStudio) {
        self.data = designStudio
        self.currentChallenge = -1
    }
    
    // this will move the design studio to the next challenge
    func getNextChallenge() -> Challenge? {
        let nextChallengeIdx = ++self.currentChallenge
        if (nextChallengeIdx < self.data!.challenges.count) {
            return self.data!.challenges[nextChallengeIdx]
        } else {
            return nil
        }
    }
    
}