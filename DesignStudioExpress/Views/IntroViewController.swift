//
//  IntroViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/10/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit
import AVFoundation
import Crashlytics
import RealmSwift

class IntroViewController: UIViewController {
    @IBOutlet weak var createButton: UIButtonRed!
    @IBOutlet weak var faqButton: UIButtonLightBlue!
    
    lazy var playerLayer:AVPlayerLayer = self.initVideoPlayer()
    let videoFileName = "Intro"
    let videoFileType = "mp4"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add video player
        self.view.layer.addSublayer(self.playerLayer)
        
        // bring buttons on top of the video
        self.view.bringSubviewToFront(createButton)
        self.view.bringSubviewToFront(faqButton)
        
        // TODO: this drops entire db
        // remove it!
        //try! NSFileManager.defaultManager().removeItemAtPath(Realm.defaultPath)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func initVideoPlayer() -> AVPlayerLayer {
        let videoBundle = NSBundle.mainBundle().pathForResource(videoFileName, ofType: videoFileType)
        let player = AVPlayer(URL:  NSURL(fileURLWithPath: videoBundle!))
        player.muted = true
        player.allowsExternalPlayback = false
        player.appliesMediaSelectionCriteriaAutomatically = false
        
        var error:NSError?
        
        // Don't cut off users audio (if listening to music etc.)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch let e as NSError {
            error = e
        } catch {
            fatalError()
        }
        if error != nil {
            CLSLogv("Error setting the AVAudioSession %@", getVaList([(error?.description)!]));
        }
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = "AVLayerVideoGravityResizeAspectFill"
        playerLayer.backgroundColor = UIColor.blackColor().CGColor
        player.play()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"playerDidReachEnd", name:AVPlayerItemDidPlayToEndTimeNotification, object:nil)
        return playerLayer
    }
    
    func playerDidReachEnd(){
       self.playerLayer.player!.seekToTime(kCMTimeZero)
       self.playerLayer.player!.play()
    }
}