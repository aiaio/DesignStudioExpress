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
    lazy var data: Results<DesignStudio> = self.loadDesignStudios()
    
    private func loadDesignStudios() -> Results<DesignStudio> {
        let realm = try! Realm()
        var designStudios = realm.objects(DesignStudio)
        
        if designStudios.count == 0 {
            createDefaultDesignStudios()
            designStudios = realm.objects(DesignStudio)
        }
        
        return designStudios
    }

    private func createDefaultDesignStudios() {
        let realm = try! Realm()
        
        realm.beginWrite()
        
        let ds1 = DesignStudio()
        ds1.title = "First template"
        ds1.duration = 120
        realm.add(ds1)
        
        let ds2 = DesignStudio()
        ds2.title = "Second template"
        ds2.duration = 60
        realm.add(ds2)

        try! realm.commitWrite()
    }
    
    func getTotalRows() -> Int {
        return data.count
    }
    
    func getTitle(indexPath: NSIndexPath) -> String {
        return data[indexPath.row].title
    }
    
    func getDetail(indexPath: NSIndexPath) -> String {
        return "\(data[indexPath.row].duration)"
    }
    
    func isRowEditable(indexPath: NSIndexPath) -> Bool {
        if indexPath.row > 2 {
            return true
        }
        
        return false
    }
    
    func swipeButtonClicked(indexPath: NSIndexPath) {
        print("Button clicked")
    }

}
