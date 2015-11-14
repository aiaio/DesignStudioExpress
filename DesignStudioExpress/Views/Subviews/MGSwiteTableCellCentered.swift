//
//  MGSwiteTabelCellCentered.swift
//  PhotoViewer
//
//  Created by Kristijan Perusko on 11/13/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation
import MGSwipeTableCell

class MGSwiteTableCellCentered: MGSwipeTableCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // make the text and detail frames full width
        // so that they can be centered
        self.textLabel!.frame = CGRectMake(0, self.textLabel!.frame.origin.y, self.frame.size.width, self.textLabel!.frame.size.height);
        self.detailTextLabel!.frame = CGRectMake(0, self.detailTextLabel!.frame.origin.y, self.frame.size.width, self.detailTextLabel!.frame.size.height);
    }
}