//
//  FaqViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/9/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit
import NRSimplePlist

class FaqViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpWebView()
    }
    
    private func setUpWebView() {
        var urlString: String
        do {
            urlString = try plistGet("WebViewUrl", forPlistNamed: "Settings") as! String
        } catch let error {
            // TODO handle errors
            print(error)
            urlString = "http://www.alexanderinteractive.com"
        }
        
        
        let url = NSURL(string: urlString)!
        let requestObj: NSURLRequest = NSURLRequest(URL: url)
        webView.loadRequest(requestObj)
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
