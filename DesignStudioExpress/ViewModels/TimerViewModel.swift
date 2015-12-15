//
//  TimerViewModel.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/3/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation
import RealmSwift
import Photos
import NRSimplePlist

class TimerViewModel {
    private var nextObject: Object?
    private var showUpcomingChallengeFlag = false
    private var showEndScreenFlag = false
        
    var currentChallenge: Challenge? {
        get { return AppDelegate.designStudio.currentChallenge }
    }
    
    var challengeTitle: String {
        get { return AppDelegate.designStudio.currentChallenge?.title ?? "" }
    }
    
    var activityTitle: String {
         get { return AppDelegate.designStudio.currentActivity?.title ?? "" }
    }
    
    var currentActivityRemainingDuration: Int {
        get { return AppDelegate.designStudio.currentActivityRemainingDuration }
    }
    
    var activityDescription: String {
        get { return AppDelegate.designStudio.currentActivity?.activityDescription ?? "" }
    }
    
    var activityNotes: String {
        get {
            if self.activityNotesEnabled {
                if let notes = AppDelegate.designStudio.currentActivity?.notes {
                    return "\"\(notes)\""
                }
            }
            return ""
        }
    }
    
    var activityNotesEnabled: Bool {
        get {
            if let notes = AppDelegate.designStudio.currentActivity?.notes {
                return notes.length > 0
            }
            return false
        }
    }
    
    // MARK - timer workflow
    
    var segueFromUpcomingChallenge: Bool = false
    
    var showUpcomingChallenge: Bool {
        get {
            return self.showUpcomingChallengeFlag
        }
    }
    
    var showEndScreen: Bool {
        get { return self.showEndScreenFlag }
    }
    
    func skipToNextActivity() {
        AppDelegate.designStudio.skipToNextActivity()
    }
    
    // MARK - Photos
    
    private var assetCollectionPlaceholder: PHObjectPlaceholder?
    
    func saveImage(image: UIImage) {
        self.getDefaultPhotoCollectionForApp({ (assetCollection: PHAssetCollection) -> Void in
            self.createImage(image, assetCollection: assetCollection)
        })
    }
    
    private func getDefaultPhotoCollectionForApp(collectionReadyCallback: (assetCollection: PHAssetCollection) -> Void) {
        let fetchOptions = PHFetchOptions()
        var defaultAlbumName = ""
        do {
            defaultAlbumName = try plistGet("AlbumName", forPlistNamed: "Settings") as! String
        } catch let error as NSError {
            // TODO handle errors
            print(error)
            return
        }
        fetchOptions.predicate = NSPredicate(format: "title = %@", defaultAlbumName) // TODO replace image
        
        let collection: PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .AlbumRegular, options: fetchOptions)
        
        if let assetCollection = collection.firstObject as? PHAssetCollection {
            collectionReadyCallback(assetCollection: assetCollection)
        } else {
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(defaultAlbumName)
                    self.assetCollectionPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
                }, completionHandler: { success, error in
                    
                    if (success) {
                        let collectionFetchResult = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers([self.assetCollectionPlaceholder!.localIdentifier], options: nil)

                        if let assetCollection = collectionFetchResult.firstObject as? PHAssetCollection {
                            collectionReadyCallback(assetCollection: assetCollection)
                        }
                    }
            })
        }
    }
    
    func createImage(image: UIImage, assetCollection: PHAssetCollection) {
    
        let changeBlock = { () -> Void in
            let assetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            if let assetPlaceholder = assetRequest.placeholderForCreatedAsset {
                let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: assetCollection)
                let fastEnum: NSArray = [assetPlaceholder]
                albumChangeRequest?.addAssets(fastEnum)
            }
        }
        
        let completionHandler = { (success: Bool, error: NSError?) -> Void in
            // TODO handle errors
        }
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges(changeBlock, completionHandler:  completionHandler)
    }
    
}