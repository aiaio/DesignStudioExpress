//
//  DesignStudioStyleCustomization.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/19/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//
import UIKit

public class DesignStudioElementStyles {
    
    // set the navigation bar
    class func transparentNavigationBar(navigationBar: UINavigationBar) {
        // NavigationBar - make navigation bar transparent
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        // remove the shadow bar
        navigationBar.shadowImage = UIImage()
    }
    
    class func pinkNavigationBar(navigationBar: UINavigationBar) {
        navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        navigationBar.barTintColor = DesignStudioStyles.primaryOrange
        navigationBar.shadowImage = UIImage()
    }
}
