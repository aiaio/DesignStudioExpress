//
//  SettingsViewModel.swift
//  DesignStudioExpress
//
//  Created by Tim Broder on 12/10/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation

struct Setting {
    let title: String
    let icon: String
}

class SettingsViewModel {
    private var data: [Setting]!
    
    init () {
        data = self.loadStaticSettings()
    }
    
    private func loadStaticSettings() -> [Setting] {
        return [
            Setting(title: "Test", icon: "Clock"),
            Setting(title: "Test2", icon: "Clock"),
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
}