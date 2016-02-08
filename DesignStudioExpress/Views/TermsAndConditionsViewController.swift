//
//  TermsAndConditionsViewController.swift
//  Design Studio Express
//
//  Created by Kristijan Perusko on 12/23/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit
import NRSimplePlist

class TermsAndConditionsViewController: UIViewControllerBase {
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Terms and Conditions"
    }
        
    // MARK: StyledNavigationBar
    
    override func customizeNavBarStyle() {
        super.customizeNavBarStyle()
        
        DesignStudioElementStyles.pinkNavigationBar(self.navigationController!.navigationBar)
    }
}
