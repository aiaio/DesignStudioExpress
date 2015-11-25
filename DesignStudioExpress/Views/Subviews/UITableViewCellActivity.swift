//
//  UITableViewCellActivity.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/22/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class UITableViewCellActivity: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var activityDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
