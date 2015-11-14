//
//  HomeViewModel.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/13/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class HomeViewModel {
    
    var data = [AnyObject]()
    
    func getTotalRows() -> Int {
        return data.count
    }
    
    func reorderRows(fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let val = self.data.removeAtIndex(fromIndexPath.row)
        
        // insert it into the new position
        self.data.insert(val, atIndex: toIndexPath.row)
    }
    
    func getTitle(indexPath: NSIndexPath) -> String {
        return "Title"
    }
    
    func getDetail(indexPath: NSIndexPath) -> String {
        return "Detail text"
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
