//
//  DetailDesignStudioViewModel.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/15/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation
import RealmSwift

class DetailDesignStudioViewModel {
    
    lazy var realm = try! Realm()
    private var data: DesignStudio?
    
    func setDesignStudio(newDesignStudio: DesignStudio?) {
        if let designStudio = newDesignStudio {
            self.data = designStudio
        } else {
            // create new DS, but don't save it until we segue to next screen
            let ds = DesignStudio()
            ds.title = "Design studio here"
            self.data = ds
        }
    }
    
    func getTitle () -> String {
        return data!.title
    }
}
