//
//  PostDesignStudioViewModel.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/14/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import MHVideoPhotoGallery
import Photos
import AssetsLibrary
import NRSimplePlist

class PostDesignStudioViewModel {
    private var designStudio: DesignStudio?
    private var data = [MHGalleryItem]()
    
    var designStudioTitle: String {
        get { return self.designStudio?.title ?? "" }
    }
    
    func setDesignStudio(designStudio: DesignStudio) {
        self.designStudio = designStudio
    }
    
    var showGallery: Bool {
        // only show the gallery if we have obtained authorization and we have some images
        return self.accessToLibraryGranted && self.data.count > 0
    }
    
    private var accessToLibraryGranted: Bool {
        return ALAssetsLibrary.authorizationStatus() == ALAuthorizationStatus.Authorized
    }
    // MARK: - Data
    
    var totalImages: Int {
        return self.data.count
    }
    
    func getAllGalleryItems() -> [MHGalleryItem] {
        return self.data
    }
    
    func getGalleryItem(index: Int) -> MHGalleryItem {
        return self.data[index]
    }
    
    func loadData(loadFinishedCallback: () -> Void) {
        // don't do anything if we didn't get the authorization from user to access gallery
        if !self.accessToLibraryGranted {
            loadFinishedCallback()
        }
        
        let assetLibrary = ALAssetsLibrary()
        let assetsType : ALAssetsGroupType = Int(ALAssetsGroupAlbum) // all albums on the device not including Photo Stream or Shared Streams
        var defaultAlbumName = ""
        do {
            defaultAlbumName = try plistGet("AlbumName", forPlistNamed: "Settings") as! String
        } catch let error {
            // TODO handle errors
            print(error)
            return
        }
        
        //remove all items when we're refreshing data
        self.data.removeAll()
        var temp = [MHGalleryItem]()
        var foundPhotoLibrary = false
        
        assetLibrary.enumerateGroupsWithTypes(assetsType, usingBlock: { (group: ALAssetsGroup!, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            
            guard group != nil && String(group.valueForProperty(ALAssetsGroupPropertyName)) == defaultAlbumName else {
                return
            }
            
            foundPhotoLibrary = true
            
            // get only photos
            group.setAssetsFilter(ALAssetsFilter.allPhotos())
            
            let totalImages = group.numberOfAssets()
            
            if totalImages == 0 {
                 loadFinishedCallback()
            }
            
            group.enumerateAssetsUsingBlock({ (asset: ALAsset!, idx, stop) -> Void in
                if asset != nil {
                    if let defaultRep = asset.defaultRepresentation() {
                        // appending and then reversing the order is faster
                        // than just inserting it at index 0
                        temp.append(MHGalleryItem(URL: defaultRep.url().absoluteString, galleryType: .Image))
                    }
                }
                
                // check that we loaded all images before calling the callback
                if idx >= totalImages - 1 {
                    // reverse the order of items so that latest image is first
                    self.data = temp.reverse()

                    loadFinishedCallback()
                }
            })
            
            }, failureBlock: { (error: NSError!) -> Void in
                // TODO handle errors
            }
        )
        
        if !foundPhotoLibrary {
            loadFinishedCallback()
        }
        
    }
}
