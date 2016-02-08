//
//  PhotoManager.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/21/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Photos
import NRSimplePlist

class PhotoManager {
    
    func createDefaultPhotoCollectionForApp() {
        // if we have the photo collection, return immediately
        if let _ = self.getDefaultPhotoCollectionForApp() {
            return
        }
        
        guard let defaultAlbumName = self.getDefaultAlbumName() else {
            return
        }
        
        let changeBlock = { () -> Void in
            let _ = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(defaultAlbumName)
        }
        
        // request authorization to access photo library
        PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) in
            if status == PHAuthorizationStatus.Authorized {
                // create a default folder for the app
                PHPhotoLibrary.sharedPhotoLibrary().performChanges(changeBlock, completionHandler: { success, error in
                    if (success) {
                        print("Photo library successfuly created")
                    } else {
                        print(error)
                    }
                })
            }
        })
    }
    
    func saveImage(image: UIImage) {
        guard let assetCollection = self.getDefaultPhotoCollectionForApp() else {
            return
        }
        
        let changeBlock = { () -> Void in
            let assetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            if let assetPlaceholder = assetRequest.placeholderForCreatedAsset {
                let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: assetCollection)
                let fastEnum: NSArray = [assetPlaceholder]
                albumChangeRequest?.addAssets(fastEnum)
            }
        }
        
        let completionHandler = { (success: Bool, error: NSError?) -> Void in
            print(error)
        }
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges(changeBlock, completionHandler:  completionHandler)
    }
    
    private func getDefaultPhotoCollectionForApp() -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        
        guard let defaultAlbumName = self.getDefaultAlbumName() else {
            return nil
        }
        
        fetchOptions.predicate = NSPredicate(format: "title = %@", defaultAlbumName)
        
        let collection: PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .AlbumRegular, options: fetchOptions)
        
        if let assetCollection = collection.firstObject as? PHAssetCollection {
            return assetCollection
        }
        return nil
    }
    
    private func getDefaultAlbumName() -> String? {
        var defaultAlbumName = ""
        do {
            defaultAlbumName = try plistGet("AlbumName", forPlistNamed: "Settings") as! String
        } catch let error {
            print(error)
            return nil
        }
        return defaultAlbumName
    }
}
