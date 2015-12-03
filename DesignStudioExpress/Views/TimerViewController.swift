//
//  TimerViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/3/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class TimerViewController: UIViewControllerBase {

    let vm = TimerViewModel()
    var currentChallenge = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showUpcomingChallenge()
    }
    
    // MARK: StyledNavigationBar
    
    override func customizeNavBarStyle() {
        super.customizeNavBarStyle()
        
        DesignStudioElementStyles.transparentNavigationBar(self.navigationController!.navigationBar)
    }
    
    // MARK: - Custom
    
    func showUpcomingChallenge() {
        
        let nextChallenge = vm.getNextChallenge()
        
        if nextChallenge == nil {
            // TODO: show end screen
        } else {
            if let upcomingChallengeView = self.storyboard?.instantiateViewControllerWithIdentifier("UpcomingChallenges") as? UpcomingChallengeViewController {
                upcomingChallengeView.vm.setChallenge(nextChallenge!)
                self.presentViewController(upcomingChallengeView, animated: true, completion: nil)
            } else {
                // TODO: handle error
            }
        }
    }
}
