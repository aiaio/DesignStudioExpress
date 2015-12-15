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
    
    init () {
        self.loadData()
    }
    
    var designStudioTitle: String {
        get { return self.designStudio?.title ?? "" }
    }
    
    func setDesignStudio(designStudio: DesignStudio) {
        self.designStudio = designStudio
    }
    
    // MARK: - Data
    
    var totalImages: Int {
        return data.count
    }
    
    func getAllGalleryItems() -> [MHGalleryItem] {
        return data
    }
    
    func getGalleryItem(index: Int) -> MHGalleryItem {
        return self.data[index]
    }
    
    private func loadData() {
        //HAssetCollection.fetchTopLevelUserCollectionsWithOptions()
        let assetLibrary = ALAssetsLibrary()
        let assetsType : ALAssetsGroupType = Int(ALAssetsGroupAlbum) // all albums on the device not including Photo Stream or Shared Streams
        var defaultAlbumName = ""
        do {
            defaultAlbumName = try plistGet("AlbumName", forPlistNamed: "Settings") as! String
        } catch let error as NSError {
            // TODO handle errors
            print(error)
            return
        }
        assetLibrary.enumerateGroupsWithTypes(assetsType, usingBlock: { (group: ALAssetsGroup!, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            
            guard group != nil && String(group.valueForProperty(ALAssetsGroupPropertyName)) == defaultAlbumName else {
                return
            }

            // get only photos
            group.setAssetsFilter(ALAssetsFilter.allPhotos())
           
            group.enumerateAssetsUsingBlock({ (asset: ALAsset!, idx, stop) -> Void in
                if asset != nil {
                    if let defaultRep = asset.defaultRepresentation() {
                        self.data.append(MHGalleryItem(URL: defaultRep.url().absoluteString, galleryType: .Image))
                    }
                }
            })
            
            }, failureBlock: { (error: NSError!) -> Void in
                // TODO handle errors
            }
        )
    }
}
