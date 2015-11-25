//
//  UITableViewCellChallengeHeader.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/22/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit
import SZTextView

class UITableViewCellChallengeHeader: UITableViewCell {

    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var title: UITextField!
    @IBOutlet weak var challengeDescription: SZTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
