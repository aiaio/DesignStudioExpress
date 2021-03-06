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
            
            self.fixDesignStudioState()
        } else {
            // create new DS, but don't save it until we segue to next screen
            createNewDesignStudio()
        }
    }
    
    // in case the the design studio is started, but not finished
    // this will fix the state
    private func fixDesignStudioState() {
        // if it's not finished and if it's not currently running
        if self.data.started && !self.data.finished && AppDelegate.designStudio.currentDesignStudio?.id != self.data.id {
            do {
                try realm.write {
                    self.data.finished = true
                }
            } catch let error as NSError {
                print("Couldn't save design studio: " + error.localizedDescription)
            }
        }
    }
    
    private func createNewDesignStudio() {
        let ds = DesignStudio()
        self.data = ds
        self.isNew = true
    }
    
    func openDesignStudio(title: String, duration: String) -> DesignStudio {
        // save the design studio when we're moving to the next screen
        if self.isNew {
            do {
                try realm.write {
                    self.realm.add(self.data)
                    self.isNew = false
                }
            } catch let error as NSError {
                print("Couldn't save a new design studio: " + error.localizedDescription)
            }
        } else {
            // in case user clicks continue while the keyboard is still active
            // save the title
            self.title = title
        }
        
        return self.data
    }

    func copyDesignStudio() -> DesignStudio? {
        if let copyDS = self.data.makeACopy() {
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(copyDS)
                }
            } catch let error as NSError {
                print("Couldn't save the Design Studio copy: " + error.localizedDescription)
                return nil
            }
           
            return copyDS
        }
        
        return nil
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
