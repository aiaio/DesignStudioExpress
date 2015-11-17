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
    lazy var data: [DesignStudio] = self.loadDesignStudios()
    
    private func loadDesignStudios() -> [DesignStudio] {
        let realm = try! Realm()
        var designStudios = realm.objects(DesignStudio).sorted("dateCreated")
        
        // TODO fix this after demo, this will add test data that we can delete
        if designStudios.count == 0 || designStudios.count < 4 {
            createDefaultDesignStudios()
            designStudios = realm.objects(DesignStudio)
        }
        
        return designStudios.toArray(DesignStudio.self)
    }

    private func createDefaultDesignStudios() {
        let realm = try! Realm()
        
        realm.beginWrite()
        
        let ds1 = DesignStudio()
        ds1.title = "First template"
        ds1.duration = 45
        realm.add(ds1)
        
        let ds2 = DesignStudio()
        ds2.title = "Second template"
        ds2.duration = 62
        realm.add(ds2)
        
        // TODO remove - test data for demo
        for item in 1...3 {
            let ds = DesignStudio()
            ds.title = "Studio " + "\(item)"
            ds.duration = 90
            realm.add(ds)
        }

        try! realm.commitWrite()
    }
    
    func getTotalRows() -> Int {
        return data.count + 1
    }
    
    
    func isRowEditable(indexPath: NSIndexPath) -> Bool {
        if indexPath.row > 2 {
            return true
        }
        
        return false
    }
    
    // handler for Delete buttonr
    // since we have only one swipe button
    func swipeButtonClicked(indexPath: NSIndexPath) -> Bool {
        let idx = indexPath.row-1
        var success = false
        
        try! self.realm.write {
            self.realm.delete(self.data[idx])
            success = true
        }
        
        data.removeAtIndex(idx)
        
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
