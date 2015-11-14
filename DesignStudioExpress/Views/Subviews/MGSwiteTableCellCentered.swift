//
//  MGSwiteTabelCellCentered.swift
//  PhotoViewer
//
//  Created by Kristijan Perusko on 11/13/15.
//  Copyright © 2015 Simon Allardice. All rights reserved.
//

import Foundation
import MGSwipeTableCell

class MGSwiteTableCellCentered: MGSwipeTableCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel!.frame = CGRectMake(0, self.textLabel!.frame.origin.y, self.frame.size.width, self.textLabel!.frame.size.height);
        self.detailTextLabel!.frame = CGRectMake(0, self.detailTextLabel!.frame.origin.y, self.frame.size.width, self.detailTextLabel!.frame.size.height);
    }
}