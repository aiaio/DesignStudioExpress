//
//  StudioEndedViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/6/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class StudioEndedViewController: UIViewController {
    let showDuration = 5.0
    
    weak var delegate: StudioEndedDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideViewAfterTimeout()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.delegate?.studioEndedWillDidDisappear()
    }
    
    func hideViewAfterTimeout() {
        NSTimer.scheduledTimerWithTimeInterval(showDuration, target: self, selector: "hideView", userInfo: nil, repeats: false)
    }
    
    func hideView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
