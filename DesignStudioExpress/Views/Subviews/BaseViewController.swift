//
//  BaseNavigationBar.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/12/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customizeNavBarStyle()
    }
    
    private func customizeNavBarStyle() {
        // remove "Back" title from all back buttons
        let backButton = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        // set the color for the back arrow
        self.navigationController?.navigationBar.tintColor = DesignStudioStyles.white
        self.navigationController?.navigationBar.barTintColor = DesignStudioStyles.primaryOrange
    }
}