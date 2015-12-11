//
//  MPFeedbackMailComposeViewController.h
//  MPFeedbackMailComposeViewController
//
//  Created by Michael Patzer on 3/5/13.
//  Copyright (c) 2013 Michael Patzer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface MPFeedbackMailComposeViewController : MFMailComposeViewController

- (void)setMessageBody:(NSString *)body isHTML:(BOOL)isHTML;

@end
