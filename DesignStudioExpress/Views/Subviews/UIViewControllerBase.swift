//
//  BaseNavigationBar.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/12/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class UIViewControllerBase: UIViewController, StyledNavigationBar {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customizeNavBarStyle()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.customizeNavBarStyle()
    }
    
    func customizeNavBarStyle() {
        // Remove "Back" title from all back buttons
        let backButton = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        // Make navigation text and buttons white
        self.navigationController?.navigationBar.tintColor = DesignStudioStyles.white
        
        // We need to set the background image so we can remove the shadow bar
        // If we need to control the color of the background navigation, 
        // we can set translucent property to true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        // Remove the shadow bar
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}