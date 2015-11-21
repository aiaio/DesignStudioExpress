//
//  ChallengeMGSwipeTableCell.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/20/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation
import MGSwipeTableCell

class MGSwipeTableCellChallenge: MGSwipeTableCell {
    
    @IBOutlet weak var challengeName: UILabel!
    @IBOutlet weak var activitiesLabel: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // this in comb. with UIEdgeInsetsZero on layoutMargins for a tableView
        // will make the cell separator show from edge to edge
        self.layoutMargins = UIEdgeInsetsZero
    }
}