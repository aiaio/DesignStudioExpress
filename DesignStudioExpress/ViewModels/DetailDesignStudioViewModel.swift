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
    
    lazy var realm = try! Realm()
    private var data: DesignStudio?
    
    func setDesignStudio(newDesignStudio: DesignStudio?) {
        if let designStudio = newDesignStudio {
            self.data = designStudio
        } else {
            // create new DS, but don't save it until we segue to next screen
            let ds = DesignStudio()
            self.data = ds
        }
    }
    
    func getTitle () -> String {
        if let title = data?.title {
            return title
        }
        return "Studio Name Goes Here"
    }
    
    func getDuration() -> String {
        if let duration = data?.duration {
            return "\(duration)"
        }
        return "\(60)"
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
