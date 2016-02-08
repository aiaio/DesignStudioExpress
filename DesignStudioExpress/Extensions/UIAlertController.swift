//
//  UIAlertController.swift
//  Design Studio
//
//  Created by Kristijan Perusko on 2/4/16.
//  Copyright © 2016 Alexander Interactive. All rights reserved.
//

extension UIAlertController {

    static func createAlertController(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)
        
        return alertController
    }
}
