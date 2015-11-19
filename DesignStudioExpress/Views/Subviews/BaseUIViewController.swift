//
//  BaseNavigationBar.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/12/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class BaseUIViewController: UIViewController, StyledNavigationBarProtocol {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customizeNavBarStyle()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.customizeNavBarStyle()
    }
    
    func customizeNavBarStyle() {
        // remove "Back" title from all back buttons
        let backButton = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        // make navigation text and buttons white
        self.navigationController?.navigationBar.tintColor = DesignStudioStyles.white
    }
}