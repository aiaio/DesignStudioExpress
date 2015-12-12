//
//  FaqViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/9/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class FaqViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "https://designstudioexpress.s3.amazonaws.com/WebView/index.html")!
        let requestObj: NSURLRequest = NSURLRequest(URL: url)
        webView.loadRequest(requestObj)
    }
    
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
