//
//  HomeViewModel.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/13/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation
import RealmSwift

class HomeViewModel {
    lazy var realm = try! Realm()
    private var data: [DesignStudio] = []
    
    init () {
        /* 
         * This will delete entire database, only for testing purposes
         *
        if let path = Realm.Configuration.defaultConfiguration.path {
            if NSFileManager.defaultManager().fileExistsAtPath(path) {
                try! NSFileManager.defaultManager().removeItemAtPath(path)
            }
        }*/
        
        data = self.loadDesignStudios()
    }
    
    private func loadDesignStudios() -> [DesignStudio] {
        let realm = try! Realm()
        var designStudios = realm.objects(DesignStudio).sorted("dateCreated")
        
        if designStudios.count == 0 {
            self.createDefaultDesignStudios()
            designStudios = realm.objects(DesignStudio)
        }
        
        return designStudios.toArray(DesignStudio.self)
    }

    private func createDefaultDesignStudios() {
        DesignStudio.createDefaultTemplate1()
        DesignStudio.createDefaultTemplate2()
    }
    
    func canDeleteDesignStudio(indexPath: NSIndexPath) -> Bool {
        // delete only design studios that are not templates
        guard self.isRowEditable(indexPath) else {
            return false
        }
        let designStudio = self.data[indexPath.row-1]
        return designStudio.id != AppDelegate.designStudio.currentDesignStudio?.id
    }
    
    func refreshData() {
        data = loadDesignStudios()
    }
    
    func getTotalRows() -> Int {
        return data.count + 1
    }
    
    func isRowEditable(indexPath: NSIndexPath) -> Bool {
        if indexPath.row - 1 < data.count && !data[indexPath.row-1].template {
            return true
        }
        
        return false
    }
    
    func deleteDesignStudio(indexPath: NSIndexPath) -> Bool {
        var success = false
        
        try! self.realm.write {
            let idx = indexPath.row-1
            let id = self.data[idx].id
            
            self.realm.delete(self.data[idx])
            self.data.removeAtIndex(idx)
            
            NSNotificationCenter.defaultCenter().postNotificationName("DesignStudioDeleted", object: self, userInfo: ["DesignStudioId": id])
            
            success = true
        }
        
        return success
    }
        
    func getTitle(indexPath: NSIndexPath) -> String {
        if indexPath.row == 0 {
            return "MY DESIGN STUDIOS"
        }
        return data[indexPath.row-1].title
    }
    
    func getDetail(indexPath: NSIndexPath) -> String {
        if indexPath.row == 0 {
            return "Start fast from a template\n or create a new one"
        }
        return "Duration \(data[indexPath.row-1].duration) min"
    }
    
    func getImageName(indexPath: NSIndexPath) -> String {
        // big image
        if indexPath.row == 0 {
            return "DS_Home_BG_image"
        }
        // icon for
        return "Clock"
    }
    
    func getData(indexPath: NSIndexPath?) -> DesignStudio? {
        guard indexPath?.row > 0 else {
            return nil
        }
        return data[indexPath!.row-1]
    }
}
