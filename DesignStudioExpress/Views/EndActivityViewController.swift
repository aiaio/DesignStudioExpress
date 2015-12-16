//
//  EndActivityViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/8/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class EndActivityViewController: UIViewController {
    @IBOutlet weak var addMoreTime: UIButtonTransparent!

    let vm = EndActivityViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addMoreTime.setTitle(vm.addMoreTimeTitle, forState: .Normal)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.vm.viewDidDisappear()
    }

    @IBAction func nextActivity(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addMoreTime(sender: AnyObject) {
        self.vm.addMoreTime()

        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
