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
    let description: String?
    let icon: String?
    // this feels icky FIXME
    let action: (UIViewController) -> ()
    
    init (title: String, description: String? = nil, icon: String? = nil, action: (UIViewController) -> ()) {
        self.title = title
        self.description = description
        self.icon = icon
        self.action = action
    }
}

class SettingsViewModel {
    private var data: [Setting]!
    
    let emailErrorMessageTitleText = "Preparing email failed"
    let emailErrorMessageMessageText = "Please configure your device to send email"
    
    init () {
        data = self.loadStaticSettings()
    }
    
    private func loadStaticSettings() -> [Setting] {
        return [
            // TODO images
            Setting(title: "Who Made This?", action:  { vc in
                let svc = SFSafariViewController(URL: NSURL(string: "http://www.alexanderinteractive.com/company/")!)
                vc.presentViewController(svc, animated: true, completion: nil)
            }),
            
            Setting(title: "Legal", action: { vc in
                let legalController = AcknowListViewController()
                if let navigationController = vc.navigationController {
                    navigationController.pushViewController(legalController, animated: true)
                }
            }),
            
            Setting(title: "Contact Us", action: { vc in
                if MFMailComposeViewController.canSendMail() {
                    // https://github.com/monkeymike/MPFeedbackMailComposeViewController
                    
                    let feedbackController = MPFeedbackMailComposeViewController()
                    
                    feedbackController.mailComposeDelegate = vc as! SettingsViewController
                    
                    // TODO update with real email
                    feedbackController.setToRecipients(["sms@alexanderinteractive.com"])
                    
                    feedbackController.setSubject("Design Studio Express Feedback")
                    feedbackController.setMessageBody("Feedback:\n\n\n\n\n\n\n\n\n--------\nDeveloper Information:", isHTML:false)
                    
                    if let navigationController = vc.navigationController {
                        navigationController.presentViewController(feedbackController, animated: true, completion:nil)
                    }
                } else {
                    // show the alert if we can send the email
                    let alertController = UIAlertController(title: self.emailErrorMessageTitleText, message: self.emailErrorMessageMessageText, preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(okAction)
                    
                    if let navigationController = vc.navigationController {
                        navigationController.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }),
            
            Setting(title: "Review on App Store", action: { vc in
                // https://itunes.apple.com/us/app/whackjob/id1054379438?at=11laRZ&ct=pro&ls=1&mt=8
                UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/app/id1054379438")!)
            }),
            
            Setting(title: "Share this app", action: { vc in
                
                //text lives in DesignStudioActivityItemSource.swift
                
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
        return data[indexPath.row-1].title
    }
    
    func getDescription(indexPath: NSIndexPath) -> String? {
        if indexPath.row == 0 {
            return "Share, adjust sound or learn\n about the nerds who built this."
        }
        return data[indexPath.row-1].description
    }
    
    func getImageName(indexPath: NSIndexPath) -> String? {
        // big image
        if indexPath.row == 0 {
            return "Settings_Image"
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
