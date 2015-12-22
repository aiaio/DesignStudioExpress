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
    private var numOfTemplates = 0
    
    init () {
        data = self.loadDesignStudios()
        
        /* 
         * This will delete entire database, only for testing purposes
         *
        if let path = Realm.Configuration.defaultConfiguration.path {
            if NSFileManager.defaultManager().fileExistsAtPath(path) {
                try! NSFileManager.defaultManager().removeItemAtPath(path)
            }
        } */
    }
    
    private func loadDesignStudios() -> [DesignStudio] {
        let realm = try! Realm()
        var designStudios = realm.objects(DesignStudio).sorted("dateCreated")
        
        if designStudios.count == 0 {
            self.createDefaultDesignStudios()
            designStudios = realm.objects(DesignStudio)
            self.numOfTemplates = designStudios.count
        }
        
        return designStudios.toArray(DesignStudio.self)
    }

    private func createDefaultDesignStudios() {
        DesignStudio.createDefaultTemplate1()
        DesignStudio.createDefaultTemplate2()
        
        /* TODO: remove test data
        let realm = try! Realm()
        realm.beginWrite()
        
        let ds2 = DesignStudio()
        ds2.title = "Second template"
        realm.add(ds2)

        for idx in 1...5 {
            let ds = DesignStudio()

            ds.title = "My studio \(idx)"
            for idx2 in 1...2 {
                let challenge = Challenge()
                challenge.title = "Challenge \(idx2)"
                challenge.challengeDescription  = "Lorem ipsum dolor sit amet, eos erant integre tractatos ne, dicta everti maiestatis in has. Aperiri reprimique id pro. Liber dolore periculis est ne."
                
                for idx3 in 1...2 {
                    let activity = Activity()
                    activity.title = "Activity \(idx3)"
                    activity.activityDescription = "Lorem ipsum dolor sit amet, eos erant integre tractatos ne, dicta everti maiestatis in has. Aperiri reprimique id pro. Liber dolore periculis est ne."
                    activity.notes = "Pri soleat nusquam at, natum diceret propriae nec et. Omittam expetendis ne pri, fabulas mentitum ut nam, reque consulatu mnesarchum his an."
                    activity.duration = 1
                    challenge.activities.append(activity)
                }
                
                ds.challenges.append(challenge)
            }
            realm.add(ds)
        }
        
        try! realm.commitWrite() */
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
        if indexPath.row > self.numOfTemplates {
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
