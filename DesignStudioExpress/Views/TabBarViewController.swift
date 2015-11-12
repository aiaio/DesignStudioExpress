//
//  UITabBarViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/11/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    let higlightedItemColor = DesignStudioStyles.bottomNavigationIconSelected
    let barItemBackgroundColor = DesignStudioStyles.bottomNavigationBGColorUnselected
    let barItemBackgroundColorSelected = DesignStudioStyles.bottomNavigationBGColorSelected
    let tabBarHeight = CGFloat(60)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeStyle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * Customize the tab bar style
     */
    private func customizeStyle() {
        // color for the highlighted item
        self.tabBar.tintColor = higlightedItemColor
        // color for the bar
        self.tabBar.barTintColor = barItemBackgroundColor
        
        // all bar icon assets are set to render as 'Original Image' to get the original item color
        // when the item is not selected
        // set the higlighted image (selected image) to be the same as original, but render it as a template
        // to get the colored version of the image
        self.tabBar.items?.forEach({ (tabBarItem) -> () in
            if let image = tabBarItem.image?.imageWithRenderingMode(.AlwaysTemplate) {
                tabBarItem.selectedImage = image
            }
            
            // remove the title and adjust the image position
            tabBarItem.title = "";
            tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        })
        
        // set the background color for the selected item
        let numOfItems = CGFloat(self.tabBar.items?.count ?? 1)
        let backgroundImage = UIImage.makeImageWithColorAndSize(self.barItemBackgroundColorSelected,
            size: CGSizeMake(tabBar.frame.width/numOfItems, self.tabBarHeight))
        self.tabBar.selectionIndicatorImage = backgroundImage
    }
    
    /**
     * Change the height of the bar
     */
    override func viewWillLayoutSubviews() {
        var tabBarFrame = self.tabBar.frame
        // default value is around 50
        tabBarFrame.size.height = self.tabBarHeight
        tabBarFrame.origin.y = self.view.frame.size.height - self.tabBarHeight
        self.tabBar.frame = tabBarFrame
    }
}


