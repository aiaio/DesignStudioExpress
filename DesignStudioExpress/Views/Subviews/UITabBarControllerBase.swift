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
        case ActivityEnded = "ActivityEnded" // when activity timer runs out
        case PrepareTimerScreen = "PrepareTimerScreen" // when user clicks next activity from End Activity screen
        case UpcomingChallengeDidAppear = "UpcomingChallengeDidAppear"
        case ShowNextTimerScreen = "ShowNextTimerScreen"
        case ShowNextChallengeScreen = "ShowNextChallengeScreen"
        case ShowEndDesignStudioScreen = "ShowEndDesignStudioScreen"
    }
    
    enum ViewControllerIdentifier: String {
        case ActivityEndedScreen = "ActivityEndedScreen"
        case ChallengesViewController = "ChallengesViewController"
        case TimerViewController = "TimerViewController"
        case DetailDesignStudioViewController = "DetailDesignStudioViewController"
        case UpcomingChallengeViewController = "UpcomingChallengeViewController"
        case EndDesignStudioViewController = "EndDesignStudioViewController"
        case PostDesignStudioViewController = "PostDesignStudioViewController"
        case FaqViewController = "FaqViewController"
    }
    
    // tabbar style customization
    let higlightedItemColor = DesignStudioStyles.bottomNavigationIconSelected
    let barItemBackgroundColor = DesignStudioStyles.bottomNavigationBGColorUnselected
    let barItemBackgroundColorSelected = DesignStudioStyles.bottomNavigationBGColorSelected
    let tabBarHeight = CGFloat(60)
    
    // flag that determines that the view should go directly to Faq screen
    // we're using this when we're comming from Initial screen
    // because we want to have the tab bar - if we segue directly, there's no tab bar
    var showFaq: Bool = false
    
    // 0-based index of the Design Studio tab
    let createDesignStudioNavTabIndex = 2
    // easy reference to the nav controller on the design studio tab
    private unowned var dsNavController: UINavigationController {
        get {
            return self.viewControllers![createDesignStudioNavTabIndex] as! UINavigationController
        }
    }
    
    private var activeDesignStudioId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customizeStyle()
        
        if showFaq {
            self.showFaqScreen()
        }
        
        self.addObservers()
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
    
    func showEndActivityScreen(notification: NSNotification) {
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier(ViewControllerIdentifier.ActivityEndedScreen.rawValue) {
            vc.modalPresentationStyle = .OverCurrentContext
            vc.modalTransitionStyle = .CrossDissolve
            
            // if we have a modal that's open, we have to open our modal from that vc
            let topController = self.findLastPresentedController()
            topController.presentViewController(vc, animated: true, completion: nil)
        }
    }

    func showTimerScreen(notification: NSNotification) {
        self.addMissingViewControllers()
        self.navigateToTimerScreen()
    }
    
    func beginDesignStudio(notification: NSNotification) {
        self.showUpcomingChallengeViewController()
    }
    
    // handler for UpcomingChallengeDidAppear notification
    // insert new the timer into the view after the Upcoming challenge screen
    // has finished loading so that we don't see the Timer being added to the nav stack
    func upcomingChallengeDidAppear(notification: NSNotification) {
        // add the timer vc into the navigation stack, so that we add it without animation
        if let timerViewController = self.storyboard?.instantiateViewControllerWithIdentifier(ViewControllerIdentifier.TimerViewController.rawValue) as? TimerViewController {
            self.dsNavController.viewControllers.append(timerViewController)
        }
    }
    
    func showNextTimerScreen(notification: NSNotification) {
        // push the timer vc into the nav controller so we have animation
        if let timerViewController = self.storyboard?.instantiateViewControllerWithIdentifier(ViewControllerIdentifier.TimerViewController.rawValue) as? TimerViewController {
            self.dsNavController.pushViewController(timerViewController, animated: true)
        }
    }
    
    func showNextChallengeScreen(notification: NSNotification) {
        self.showUpcomingChallengeViewController()
    }
    
    func showEndDesignStudioScreen(notification: NSNotification) {
        if let endStudio = self.storyboard?.instantiateViewControllerWithIdentifier(ViewControllerIdentifier.EndDesignStudioViewController.rawValue) as? EndDesignStudioViewController {
            endStudio.modalPresentationStyle = .FullScreen
            endStudio.modalTransitionStyle = .CrossDissolve
            self.presentViewController(endStudio, animated: true, completion: nil)
            
            // add post view studio in the view hierarchy, so when the End design studio disappears
            // we will see the post studio screen
            if let postStudio = self.storyboard?.instantiateViewControllerWithIdentifier(ViewControllerIdentifier.PostDesignStudioViewController.rawValue) {
                self.dsNavController.viewControllers.append(postStudio)
            }
        }
    }
    
    
    
    // shows the Faq screen
    private func showFaqScreen() {
        self.selectedIndex = 1
        
        if let vc = self.viewControllers![1] as? UINavigationController {
            if let faqViewController = self.storyboard?.instantiateViewControllerWithIdentifier(ViewControllerIdentifier.FaqViewController.rawValue) {
                vc.pushViewController(faqViewController, animated: false)
            }
        }
    }
    
    // register for notifications
    private func addObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showDesignStudio:", name: NotificationIdentifier.DesignStudioLoaded.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resetCurrentlyActiveDesignStudio:", name: NotificationIdentifier.DesignStudioDeleted.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showEndActivityScreen:", name: NotificationIdentifier.ActivityEnded.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showTimerScreen:", name: NotificationIdentifier.PrepareTimerScreen.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "beginDesignStudio:", name: NotificationIdentifier.DesignStudioStarted.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "upcomingChallengeDidAppear:", name: NotificationIdentifier.UpcomingChallengeDidAppear.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showNextTimerScreen:", name: NotificationIdentifier.ShowNextTimerScreen.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showNextChallengeScreen:", name: NotificationIdentifier.ShowNextChallengeScreen.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showEndDesignStudioScreen:", name: NotificationIdentifier.ShowEndDesignStudioScreen.rawValue, object: nil)
    }
    
    // remove 
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    private func setActiveDesignStudio(designStudio: DesignStudio?) {
        let designStudioViewController = self.dsNavController.viewControllers[0] as! DetailDesignStudioViewController
        designStudioViewController.vm.setDesignStudio(designStudio)
        
        // show the first view in the navigation
        self.dsNavController.popToRootViewControllerAnimated(true)
    }
    
    private func showUpcomingChallengeViewController() {
        if let upcomingChallenge = self.storyboard?.instantiateViewControllerWithIdentifier(ViewControllerIdentifier.UpcomingChallengeViewController.rawValue) as? UpcomingChallengeViewController {
            upcomingChallenge.modalPresentationStyle = .FullScreen
            upcomingChallenge.modalTransitionStyle = .CrossDissolve
            self.presentViewController(upcomingChallenge, animated: true, completion: nil)
        }
    }
    
    private func addMissingViewControllers() {
        // remove everything from the stack
        // so we don't get weird edge cases
        // calling removeAll directly does not remove them
        var vc = self.dsNavController.viewControllers
        vc.removeAll()
        self.dsNavController.viewControllers = vc
        
        if let challengesList = self.storyboard?.instantiateViewControllerWithIdentifier(ViewControllerIdentifier.DetailDesignStudioViewController.rawValue) as? DetailDesignStudioViewController {
            challengesList.vm.setDesignStudio(AppDelegate.designStudio.currentDesignStudio!)
            self.dsNavController.viewControllers.append(challengesList)
        }
        
        if let challengesList = self.storyboard?.instantiateViewControllerWithIdentifier(ViewControllerIdentifier.ChallengesViewController.rawValue) as? ChallengesViewController {
            challengesList.vm.setDesignStudio(AppDelegate.designStudio.currentDesignStudio!)
            self.dsNavController.viewControllers.append(challengesList)
        }
        
        if let timerList = self.storyboard?.instantiateViewControllerWithIdentifier(ViewControllerIdentifier.TimerViewController.rawValue) as? TimerViewController {
            self.dsNavController.viewControllers.append(timerList)
        }
    }    
    
    private func navigateToTimerScreen() {
        // if the top vc is modal, we need to dismiss it, so that we can show the timer page
        // TODO we should find a better way to test for this
        // because if we're adding more modals this will not work
        let topController = self.findLastPresentedController()
        if topController is ActivityDetailViewController {
            topController.dismissViewControllerAnimated(false, completion: nil)
        }
                
        // jump to design studio tab
        self.selectedIndex = createDesignStudioNavTabIndex
    }
    
    // finds the last presented controller in our view hierarchy
    private func findLastPresentedController() -> UIViewController {
        var topController = UIApplication.sharedApplication().keyWindow!.rootViewController;
        
        while topController?.presentedViewController != nil {
            topController = topController!.presentedViewController;
        }
        
        return topController!
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
}


