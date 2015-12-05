//
//  UpcomingChallengeViewControllerViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/3/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit
import FXLabel

class UpcomingChallengeViewController: UIViewController {
    @IBOutlet weak var numOfChallenges: FXLabel!
    @IBOutlet weak var challengeTitle: UILabel!
    @IBOutlet weak var duration: UILabel!

    let showDuration = 5.0 // TODO: increase this after testing seconds
    let vm = UpcomingChallengeViewModel()
    weak var delegate: UpcomingChallengeDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.populateFields()
        self.hideViewAfterTimeout()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.delegate?.upcomingChallengeWillDisappear()
    }
    
    func populateFields() {
        self.numOfChallenges.text = self.vm.challengeCount
        self.challengeTitle.text = self.vm.title
        self.duration.text = self.vm.duration
    }
    
    func hideViewAfterTimeout() {
        NSTimer.scheduledTimerWithTimeInterval(showDuration, target: self, selector: "hideView", userInfo: nil, repeats: false)
    }
    
    func hideView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
