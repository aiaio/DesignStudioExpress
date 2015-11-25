//
//  UITextDelegateBase.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/25/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation
import UIKit

class UITextDelegateBase: NSObject {
    
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