//
//  UITabBarViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/11/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class UITabBarControllerBase: UITabBarController {
    
    enum NotificationIdentifier: String {
        case DesignStudioLoaded = "DesignStudioLoaded"
        case DesignStudioDeleted = "DesignStudioDeleted"
        case DesignStudioStarted = "DesignStudioStarted"
        case ActivityEnded = "ActivityEnded"
        case EndActivityMoveToNextActivity = "EndActivityMoveToNextActivity"
    }
    
    enum ViewControllerIdentifier: String {
        case ActivityEndedScreen = "ActivityEndedScreen"
        case ChallengesViewController = "ChallengesViewController"
        case TimerViewController = "TimerViewController"
        case DetailDesignStudioViewController = "DetailDesignStudioViewController"
        case UpcomingChallengeViewController = "UpcomingChallengeViewController"
    }
    
    // tabbar style customization
    let higlightedItemColor = DesignStudioStyles.bottomNavigationIconSelected
    let barItemBackgroundColor = DesignStudioStyles.bottomNavigationBGColorUnselected
    let barItemBackgroundColorSelected = DesignStudioStyles.bottomNavigationBGColorSelected
    let tabBarHeight = CGFloat(60)
    
    let createDesignStudioNavTabIndex = 2
    
    private var activeDesignStudioId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customizeStyle()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showDesignStudio:", name: NotificationIdentifier.DesignStudioLoaded.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resetCurrentlyActiveDesignStudio:", name: NotificationIdentifier.DesignStudioDeleted.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showEndActivityScreen:", name: NotificationIdentifier.ActivityEnded.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showTimerScreen:", name: NotificationIdentifier.EndActivityMoveToNextActivity.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "beginDesignStudio:", name: NotificationIdentifier.DesignStudioStarted.rawValue, object: nil)
    }
    
    // handler for showing the Detail DS screen when DesignStudioLoaded notification is raised
    func showDesignStudio(notification: NSNotification) {
        // get the data from the notification
        let userInfo = notification.userInfo as? [String: AnyObject]
        let designStudio = userInfo?["DesignStudio"] as? DesignStudio
        activeDesignStudioId = designStudio?.id

        self.setActiveDesignStudio(designStudio)
        
        // jump to design studio tab
        self.selectedIndex = createDesignStudioNavTabIndex
    }
    
    func resetCurrentlyActiveDesignStudio (notification: NSNotification) {
        let userInfo = notification.userInfo as? [String: AnyObject]
        let deletedDesignStudioId = userInfo?["DesignStudioId"] as? String

        if activeDesignStudioId == deletedDesignStudioId {
            self.setActiveDesignStudio(nil)
        }
    }
    
    private func setActiveDesignStudio(designStudio: DesignStudio?) {
        let navViewController = self.viewControllers![createDesignStudioNavTabIndex] as! UINavigationController
        let designStudioViewController = navViewController.viewControllers[0] as! DetailDesignStudioViewController
        designStudioViewController.vm.setDesignStudio(designStudio)
        
        // show the first view in the navigation
        navViewController.popToRootViewControllerAnimated(true)
    }
    
    func showEndActivityScreen(notification: NSNotification) {
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier(ViewControllerIdentifier.ActivityEndedScreen.rawValue) {
            vc.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            
            // if we have a modal that's open, we have to open our modal from that vc
            let topController = self.findLastPresentedController()
            topController.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    // finds the last presented controller in our view hierarchy
    private func findLastPresentedController() -> UIViewController {
        var topController = UIApplication.sharedApplication().keyWindow!.rootViewController;
    
        while topController?.presentedViewController != nil {
            topController = topController!.presentedViewController;
        }
    
     	   return topController!
    }
    
    func showTimerScreen(notification: NSNotification) {
        self.addMissingViewControllers()
        
        self.navigateToTimerScreen()
    }
    
    func beginDesignStudio(notification: NSNotification) {
        self.showUpcomingChallengeViewController()
    }
    
    func addMissingViewControllers() {
        let navViewController = self.viewControllers![createDesignStudioNavTabIndex] as! UINavigationController
        // remove everything from the stack 
        // so we don't get weird edge cases
        // calling removeAll directly does not remove them
        var vc = navViewController.viewControllers
        vc.removeAll()
        navViewController.viewControllers = vc
        
        if let challengesList = self.storyboard?.instantiateViewControllerWithIdentifier(ViewControllerIdentifier.DetailDesignStudioViewController.rawValue) as? DetailDesignStudioViewController {
            challengesList.vm.setDesignStudio(AppDelegate.designStudio.currentDesignStudio!)
            navViewController.viewControllers.append(challengesList)
        }
        
        if let challengesList = self.storyboard?.instantiateViewControllerWithIdentifier(ViewControllerIdentifier.ChallengesViewController.rawValue) as? ChallengesViewController {
            challengesList.vm.setDesignStudio(AppDelegate.designStudio.currentDesignStudio!)
            navViewController.viewControllers.append(challengesList)
        }
        
        if let timerList = self.storyboard?.instantiateViewControllerWithIdentifier(ViewControllerIdentifier.TimerViewController.rawValue) as? TimerViewController {
            navViewController.viewControllers.append(timerList)
        }
    }
    
    func navigateToTimerScreen() {
        // if the top vc is modal, we need to dismiss it, so that we can show the timer page
        // TODO we should find a better way to test for this
        // because if we're adding more modals this will not work
        let topController = self.findLastPresentedController()
        if topController is ActivityDetailViewController {
            topController.dismissViewControllerAnimated(false, completion: nil)
        }
        
        let navViewController = self.viewControllers![createDesignStudioNavTabIndex] as! UINavigationController
        let timerVC = navViewController.viewControllers[navViewController.viewControllers.endIndex-1] // endIndex is "past-the-end"
        navigationController?.popToViewController(timerVC, animated: true)
        
        // jump to design studio tab
        self.selectedIndex = createDesignStudioNavTabIndex
    }
    
    private func showUpcomingChallengeViewController() {
        if let upcomingChallenge = self.storyboard?.instantiateViewControllerWithIdentifier(ViewControllerIdentifier.UpcomingChallengeViewController.rawValue) as? UpcomingChallengeViewController {
            upcomingChallenge.modalPresentationStyle = .FullScreen
            self.presentViewController(upcomingChallenge, animated: true, completion: nil)
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     * Customize the tab bar style
     */
    private func customizeStyle() {
        // Set empty background image, so that we can remove the tab bar shadow
        self.tabBar.backgroundImage = UIImage()
        // Set empty shadow image
        self.tabBar.shadowImage = UIImage()
        // make the tab bar not translucen, so that we can apply back. color
        self.tabBar.translucent = false
        
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


