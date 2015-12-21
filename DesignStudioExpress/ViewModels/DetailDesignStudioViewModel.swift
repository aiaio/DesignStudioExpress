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
    enum FieldName {
        case Title
        case Duration
    }
    
    let newStudioButtonText = "CREATE"
    let editStudioButtonText = "CONTINUE"
    
    lazy var realm = try! Realm()
    private var data: DesignStudio!
    private var isNew = false
    
    var title: String {
        get {
            return self.data.title
        }
        set {
            try! self.realm.write {
                self.data.title = newValue
            }
        }
    }
    
    var duration: String {
        get {
            return "\(data.duration)"
        }
        set {
            /* Duration on DesignStudio is now a sum of all durations from activities
            * functionality is left commented so that we can revert this decision
            * in future phases
            *
            try! realm.write {
                self.data.duration = Int(newValue) ?? 0
            }
            */
        }
    }
    
    var challenges: String {
        get {
            let challengesCount = data.challenges.count
            
            // handle plural version of the label
            var challengeLabel = "challenge"
            if (challengesCount != 1) {
                challengeLabel += "s"
            }
            
            return "(\(challengesCount) \(challengeLabel))"
        }
    }
    
    var buttonTitle: String {
        get {
            if self.isNew {
                return newStudioButtonText
            }
            return editStudioButtonText
        }
    }
    
    var editIconImage: String {
        get {
            if self.editingEnabled {
                return "Pencil_Icon_Blue"
            }
            return "Lock_icon_White"
        }
    }
    
    var editingEnabled: Bool {
        get { return !self.data.started && !self.data.template }
    }
    
    init () {
        self.createNewDesignStudio()
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
        self.data = ds
        self.isNew = true
    }
    
    func openDesignStudio(title: String, duration: String) -> DesignStudio {
        // save the design studio when we're moving to the next screen
        if self.isNew {
            try! realm.write {
                self.realm.add(self.data)
                self.isNew = false
            }
        } else {
            // in case user clicks continue while the keyboard is still active
            // save the title
            self.title = title
        }
        
        return self.data
    }
        
    // TODO we should probably
    func copyDesignStudio() -> DesignStudio? {
        return self.data.makeACopy()
    }
    
    private func checkMaxLength(textFieldLength: Int, range: NSRange, replacementStringLength: Int, maxAllowedLength: Int) -> Bool {
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
