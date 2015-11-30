//
//  DesignStudioStyleCustomization.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/19/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//
import UIKit
import MGSwipeTableCell

public class DesignStudioElementStyles {
    
    // set the navigation bar
    class func transparentNavigationBar(navigationBar: UINavigationBar) {
        navigationBar.translucent = true
    }
    
    class func pinkNavigationBar(navigationBar: UINavigationBar) {
        // If the background image is set, we need this so that the barTintColor is visible
        navigationBar.translucent = false
        // Background color for the nav bar
        navigationBar.barTintColor = DesignStudioStyles.primaryOrange
        // set the Title text color
        navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Avenir-Book", size: 18)!
        ]
    }
    
    class func swipeDeleteButtonRed () -> MGSwipeButton {
        let button = MGSwipeButton(title: "Delete", backgroundColor: DesignStudioStyles.primaryOrange)
        button.setTitleColor(DesignStudioStyles.white, forState: .Normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Book", size: 13.0)
        return button
    }
    
    class func swipeDeleteButtonWhite () -> MGSwipeButton {
        let button = MGSwipeButton(title: "Delete", backgroundColor: DesignStudioStyles.white)
        button.setTitleColor(DesignStudioStyles.primaryOrange, forState: .Normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Book", size: 13.0)
        return button
    }
}
