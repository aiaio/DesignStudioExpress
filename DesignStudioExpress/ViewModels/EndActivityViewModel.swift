//
//  EndActivityViewModel.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/8/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation

class EndActivityViewModel {
    func nextActivity() {
        AppDelegate.designStudio.getNextObject()
        self.raiseNotification()
    }
    
    func addMoreTime() {
        AppDelegate.designStudio.addMoreTimeToActivity()
        self.raiseNotification()
    }
    
    func raiseNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName("EndActivityWillDisappear", object: self, userInfo: nil)
    }
}