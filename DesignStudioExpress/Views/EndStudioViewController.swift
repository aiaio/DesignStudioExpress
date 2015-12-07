//
//  EndStudioViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/6/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class EndStudioViewController: UIViewControllerBase {

    // MARK: StyledNavigationBar
    
    override func customizeNavBarStyle() {
        super.customizeNavBarStyle()
        
        DesignStudioElementStyles.transparentNavigationBar(self.navigationController!.navigationBar)
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    
}
