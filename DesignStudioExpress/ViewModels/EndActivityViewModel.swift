//
//  EndActivityViewModel.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/8/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//
import NRSimplePlist

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
                // TODO handle errors
                print(error)
                duration = 1
            }
            
            if duration == 1 {
                return "ADD \(duration) MINUTE"
            }
            return "ADD \(duration) MINUTES"
        }
    }
    
    func viewDidDisappear() {
        if self.didAddMoreTime {
            AppDelegate.designStudio.addMoreTimeViewDidDisappear()
        } else {
            AppDelegate.designStudio.endCurrentActivityViewDidDisappear()
        }
    }
        
    func addMoreTime() {
        self.didAddMoreTime = true
    }
}