//
//  MPFeedbackMailComposeViewController.m
//  MPFeedbackMailComposeViewController
//
//  Created by Michael Patzer on 3/5/13.
//  Copyright (c) 2013 Michael Patzer. All rights reserved.
//

#import "MPFeedbackMailComposeViewController.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation MPFeedbackMailComposeViewController

- (id)init {
    self = [super init];
    if (self) {
        [self setMessageBody:nil isHTML:NO];
    }
    return self;
}

- (void)setMessageBody:(NSString *)body isHTML:(BOOL)isHTML {
    // Create a string object in case a nil parameter is used
    if (!body) {
        body = @"";
    }
    body = [body stringByAppendingFormat:@"\n\n%@: %@", NSLocalizedString(@"App name", nil), [self appName]];
    body = [body stringByAppendingFormat:@"\n%@: %@", NSLocalizedString(@"App version", nil), [self appVersion]];
    body = [body stringByAppendingFormat:@"\n%@: %@", NSLocalizedString(@"Device", nil), [self device]];
    body = [body stringByAppendingFormat:@"\n%@: %@", NSLocalizedString(@"Device name", nil), [self deviceName]];
    body = [body stringByAppendingFormat:@"\n%@: %@", NSLocalizedString(@"iOS version", nil), [self systemVersion]];
    body = [body stringByAppendingFormat:@"\n%@: %@", NSLocalizedString(@"Language", nil), [self language]];
    body = [body stringByAppendingFormat:@"\n%@: %@", NSLocalizedString(@"Country Code", nil), [self country]];
    body = [body stringByAppendingFormat:@"\n%@: %@", NSLocalizedString(@"Carrier", nil), [self carrier]];
    body = [body stringByAppendingFormat:@"\n%@: %@", NSLocalizedString(@"Screen Resolution", nil), [self screenResolution]];
    body = [body stringByAppendingFormat:@"\n%@: %@", NSLocalizedString(@"Orientation", nil), [self orientation]];
    body = [body stringByAppendingFormat:@"\n%@: %@", NSLocalizedString(@"Battery state", nil), [self batteryState]];
    body = [body stringByAppendingFormat:@"\n%@: %@", NSLocalizedString(@"Battery level", nil), [self batteryLevel]];
    [super setMessageBody:body isHTML:isHTML];
}

// Device
- (NSString *)device {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

// Operating system version
- (NSString *)systemVersion {
	return [[UIDevice currentDevice] systemVersion];
}

// Carrier
- (NSString *)carrier {
	if (NSClassFromString(@"CTTelephonyNetworkInfo")) {
		CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
		CTCarrier *carrier = [networkInfo subscriberCellularProvider];
        if (carrier) {
            return [carrier carrierName];
        }
	}
    
	return NSLocalizedString(@"Not available.", nil);
}

// Language
- (NSString *)language {
    return [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
}

// Country
- (NSString *)country {
    return [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
}

// App version
- (NSString *)appVersion {
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if ([version length] == 0) {
        version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    }
    
    return version;
}

// App name
- (NSString *)appName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

// Screen resolution
- (NSString *)screenResolution {
	CGRect bounds = [[UIScreen mainScreen] bounds];
	CGFloat scale = [[UIScreen mainScreen] respondsToSelector:@selector(scale)]
    ? [[UIScreen mainScreen] scale]
    : 1.0f;
	CGSize resolution = CGSizeMake(bounds.size.width * scale,
                                   bounds.size.height * scale);
	return [NSString stringWithFormat:@"%g x %g", resolution.width, resolution.height];
}

// Battery Level
- (NSString *)batteryLevel {
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    float batteryLevel = [[UIDevice currentDevice] batteryLevel];
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:NO];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
    return [formatter stringFromNumber:@(batteryLevel)];
}

// Battery State
- (NSString *)batteryState {
    NSString *batteryStateString;
    
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    UIDeviceBatteryState batteryState = [[UIDevice currentDevice] batteryState];
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:NO];
    
    switch (batteryState) {
        case UIDeviceBatteryStateUnplugged:
            batteryStateString = NSLocalizedString(@"Unplugged", nil);
            break;
        case UIDeviceBatteryStateCharging:
            batteryStateString = NSLocalizedString(@"Charging", nil);
            break;
        case UIDeviceBatteryStateFull:
            batteryStateString = NSLocalizedString(@"Full", nil);
            break;
        default:
            batteryStateString = NSLocalizedString(@"Unknown", nil);
            break;
    }
    
    return batteryStateString;
}

// Device orientation
- (NSString *)orientation {
    NSString *orientationString;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            orientationString = NSLocalizedString(@"Portrait Upside-Down", nil);
            break;
        case UIInterfaceOrientationPortrait:
            orientationString = NSLocalizedString(@"Portrait", nil);
            break;
        case UIInterfaceOrientationLandscapeRight:
            orientationString = NSLocalizedString(@"Landscape Right", nil);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            orientationString = NSLocalizedString(@"Landscape Left", nil);
            break;
        default:
            orientationString = NSLocalizedString(@"Unknown", nil);
            break;
    }
    
    return orientationString;
}

// Device name
- (NSString *)deviceName {
	return [[UIDevice currentDevice] name];
}

@end
