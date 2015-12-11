//
//  SettingsViewModel.swift
//  DesignStudioExpress
//
//  Created by Tim Broder on 12/10/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation
import SafariServices
import AcknowList

struct Setting {
    let title: String
    let icon: String
    
    // this feels icky FIXME
    let action: (UIViewController) -> ()
}

class SettingsViewModel {
    private var data: [Setting]!
    
    init () {
        data = self.loadStaticSettings()
    }
    
    private func loadStaticSettings() -> [Setting] {
        return [
            // TODO images
            // TODO closures for actions
            Setting(title: "About Ai", icon: "Clock", action:  { vc in
                let svc = SFSafariViewController(URL: NSURL(string: "http://www.alexanderinteractive.com/company/")!)
                vc.presentViewController(svc, animated: true, completion: nil)
            }),
            
            Setting(title: "Legal", icon: "Clock", action: { vc in
                let legalController = AcknowListViewController()
                if let navigationController = vc.navigationController {
                    navigationController.pushViewController(legalController, animated: true)
                }
            }),
            
            Setting(title: "Contact Us", icon: "Clock", action: { vc in
                var feedbackController = MPFeedbackMailComposeViewController()
                
                //feedbackController.mailComposeDelegate = vc
                feedbackController.setToRecipients(["sms@alexanderinteractive.com"])
                feedbackController.setSubject("Design Studio Express Feedback")
                feedbackController.setMessageBody("Feedback:\n\n\n\n\n\n\n\n\n--------\nDeveloper Information:", isHTML:false)
                
                if let navigationController = vc.navigationController {
                    navigationController.presentViewController(feedbackController, animated: true, completion:nil)
                }
            }),
            
            Setting(title: "Review on App Store", icon: "Clock", action: { vc in
                // https://itunes.apple.com/us/app/whackjob/id1054379438?at=11laRZ&ct=pro&ls=1&mt=8
                UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/app/id1054379438")!)
            }),
            
            Setting(title: "Share this app", icon: "Clock", action: { vc in
                let activityController = UIActivityViewController(activityItems: [DesignStudioActivityItemSource()], applicationActivities: nil)
                if let navigationController = vc.navigationController {
                    navigationController.presentViewController(activityController, animated: true, completion:nil)
                }
            })
                //Setting(title: "The team", icon: "Clock"), // Github pod?
        ]
    }
    
    func getTotalRows() -> Int {
        return data.count + 1
    }
    
    func getData(indexPath: NSIndexPath?) -> Setting? {
        guard indexPath?.row > 0 else {
            return nil
        }
        return data[indexPath!.row-1]
    }
    
    func getTitle(indexPath: NSIndexPath) -> String {
        if indexPath.row == 0 {
            return "SETTINGS"
        }
        return data[indexPath.row-1].title
    }
    
    
    func getImageName(indexPath: NSIndexPath) -> String {
        // big image
        if indexPath.row == 0 {
            return "DS_Home_BG_image"
        }
        // row icon
        return data[indexPath.row-1].icon
    }
    
    func getAction (indexPath: NSIndexPath) -> ((UIViewController) -> ())? {
        if indexPath.row == 0 {

            return nil
        }
        return data[indexPath.row-1].action
    }
}
