//
//  EndActivityViewModel.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/8/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//
import NRSimplePlist
import AudioToolbox

class EndActivityViewModel {
    var didAddMoreTime = false
    
    var addMoreTimeTitle: String {
        get {
            var duration = 0
            do {
                duration = try plistGet("AddMoreTimeMinutes", forPlistNamed: "Settings") as! Int
                
                if duration < 1 {
                    duration = 1
                }
            } catch let error {
                print(error)
                duration = 1
            }
            
            if duration == 1 {
                return "ADD \(duration) MINUTE"
            }
            return "ADD \(duration) MINUTES"
        }
    }
    
    func viewDidAppear() {
        // play alarm sound
        // http://iphonedevwiki.net/index.php/AudioServices
        AudioServicesPlayAlertSound(1304)
        // play vibration sound
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
    
    func viewDidDisappear() {
        if self.didAddMoreTime {
            AppDelegate.designStudio.addMoreTimeViewDidDisappear()
        } else {
            AppDelegate.designStudio.endCurrentActivityViewDidDisappear()
        }
    }
        
    func addMoreTime() {
        // just set a flag, triggering of the action will happen
        // on viewDidDisappear
        self.didAddMoreTime = true
    }
}