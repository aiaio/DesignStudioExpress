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
    enum FieldNames {
        case Title
        case Duration
    }
    
    let newStudioNameText = "Studio Name Goes Here"
    let newStudioButtonText = "CREATE"
    let editStudioButtonText = "OPEN"
    
    lazy var realm = try! Realm()
    private var data: DesignStudio!
    private var isNew = false
    
    init () {
        createNewDesignStudio()
    }
    
    func setDesignStudio(newDesignStudio: DesignStudio?) {
        if let designStudio = newDesignStudio {
            self.data = designStudio
            isNew = false
        } else {
            // create new DS, but don't save it until we segue to next screen
            createNewDesignStudio()
        }
    }
    
    func createNewDesignStudio() {
        let ds = DesignStudio()
        ds.title = self.newStudioNameText
        self.data = ds
        self.isNew = true
    }
    
    func getTitle () -> String {
        return self.data.title
    }
    
    func setTitle(newTitle: String) {
        try! realm.write {
            self.data.title = newTitle
        }
    }
    
    func getDuration() -> String {
        return "\(data.duration)"
    }
    
    /* Duration on DesignStudio is now a sum of all durations from activities
     * functionality is left commented so that we can revert this decision 
     * in future phases
    func setDuration(newDuration: String) {
        try! realm.write {
            //self.data.duration = Int(newDuration) ?? 0
        }
    }
    */
    
    func getButtonTitle() -> String {
        if isNew {
            return newStudioButtonText
        }
        return editStudioButtonText
    }
    
    func openDesignStudio(title: String, duration: String) -> DesignStudio {
        // save the design studio when we're moving to the next screen
        if isNew {
            try! realm.write {
                self.realm.add(self.data)
                self.isNew = false
            }
        } else {
            // in case user clicks continue while the keyboard is still active
            self.setTitle(title)
        }
        
        return self.data
    }
    
    func maxLengthExceeded(fieldType: FieldNames, textFieldLength: Int, range: NSRange, replacementStringLength: Int) -> Bool {
        var maxLength = 0
        if fieldType == .Title {
            maxLength = 30
        } else if fieldType == .Duration {
            maxLength = 3
        } else {
            maxLength = 0
        }
    
        return checkMaxLength(textFieldLength, range: range, replacementStringLength: replacementStringLength, maxAllowedLength: maxLength)
    }
    
    func checkMaxLength(textFieldLength: Int, range: NSRange, replacementStringLength: Int, maxAllowedLength: Int) -> Bool {
        // prevents Undo bug
        // check http://stackoverflow.com/a/1773257/515053 for reference
        if (range.length + range.location > textFieldLength )
        {
            return false;
        }
        
        let newLength = textFieldLength + replacementStringLength - range.length
        return newLength <= maxAllowedLength
    }
}
