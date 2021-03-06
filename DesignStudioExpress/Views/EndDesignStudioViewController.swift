//
//  EndDesignStudioViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/6/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class EndDesignStudioViewController: UIViewController {
    
    let showDuration = 5.0
    
    let vm = EndDesignStudioViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideViewAfterTimeout()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.vm.endDesignStudioDidAppear()
    }
    
    func hideViewAfterTimeout() {
        NSTimer.scheduledTimerWithTimeInterval(showDuration, target: self, selector: "hideView", userInfo: nil, repeats: false)
    }
    
    func hideView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
