//
//  IntroViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/10/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var faq: UIButton!

    let homeButtonColor = UIColor(red:1.00, green:0.48, blue:0.40, alpha:1.0)
    let faqButtonColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
    let buttonRadius = CGFloat(3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
/*
        // change the button designs
        homeButton.layer.cornerRadius = buttonRadius
        homeButton.layer.borderWidth = 1
        homeButton.layer.borderColor = homeButtonColor.CGColor
        homeButton.backgroundColor = homeButtonColor

        faq.layer.cornerRadius = buttonRadius
        faq.layer.borderWidth = 1
        faq.layer.borderColor = faqButtonColor.CGColor
        faq.backgroundColor = faqButtonColor*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
