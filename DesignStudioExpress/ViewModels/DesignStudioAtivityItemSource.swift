//
//  DesignStudioAtivityItemSource.swift
//  DesignStudioExpress
//
//  Created by Tim Broder on 12/11/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation

class DesignStudioActivityItemSource: NSObject, UIActivityItemSource {
    
    func activityViewControllerPlaceholderItem(activityViewController: UIActivityViewController) -> AnyObject {
        return ""
    }
    
    func activityViewController(activityViewController: UIActivityViewController, itemForActivityType activityType: String) -> AnyObject? {
        if activityType == UIActivityTypeMessage {
            return "Solve design problems fast with Design Studio Express. DSX makes running a design studio easy. It guides your team through timed rounds to brainstorm, refine and present ideas — saving photos and templates, too! @aiaio #designstudio #designstudioexpress http://by.ai/dsx"
        } else if activityType == UIActivityTypeMail {
            return "Solve design problems fast with Design Studio Express. DSX makes running a design studio easy. It guides your team through timed rounds to brainstorm, refine and present ideas — saving photos and templates, too! @aiaio #designstudio #designstudioexpress http://by.ai/dsx"
        } else if activityType == UIActivityTypePostToTwitter {
            return "DesignStudioExpress guides teams through timed rounds of brainstorming to solve design challenges fast! @aiaio #DSX http://by.ai/dsx"
        } else if activityType == UIActivityTypePostToFacebook {
            return "String message" //this is no longer supported in facebook app
        }
        return nil
    }
    
    func activityViewController(activityViewController: UIActivityViewController, subjectForActivityType activityType: String?) -> String {
        if activityType == UIActivityTypeMessage {
            return "Design Studio Express - like brainstorming on steroids"
        } else if activityType == UIActivityTypeMail {
            return "Design Studio Express - like brainstorming on steroids"
        } else if activityType == UIActivityTypePostToTwitter {
            return ""
        } else if activityType == UIActivityTypePostToFacebook {
            return "Design Studio Express - like brainstorming on steroids"
        }
        return ""
    }
    
    func activityViewController(activityViewController: UIActivityViewController, thumbnailImageForActivityType activityType: String?, suggestedSize size: CGSize) -> UIImage? {
        if activityType == UIActivityTypeMessage {
            return UIImage(named: "thumbnail-for-message")
        } else if activityType == UIActivityTypeMail {
            return UIImage(named: "thumbnail-for-mail")
        } else if activityType == UIActivityTypePostToTwitter {
            return UIImage(named: "thumbnail-for-twitter")
        } else if activityType == UIActivityTypePostToFacebook {
            return UIImage(named: "thumbnail-for-facebook")
        }
        return UIImage(named: "some-default-thumbnail")
    }
}