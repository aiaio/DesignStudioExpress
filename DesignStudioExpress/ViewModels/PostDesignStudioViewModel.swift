//
//  PostDesignStudioViewModel.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/14/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import MHVideoPhotoGallery
import Photos

class PostDesignStudioViewModel {
    private var designStudio: DesignStudio?
    private var data = [MHGalleryItem]()
    
    // TODO REMOVE
    init () {
        /*for _ in 1...100 {
            self.data.append(MHGalleryItem (URL: "https://placeholdit.imgix.net/~text?txtsize=28&txt=300%C3%97300&w=300&h=300", galleryType: MHGalleryType.Image))
        }*/
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
        let collection = PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype: .SmartAlbumUserLibrary, options: nil)
        
        guard let rec = collection.firstObject as? PHAssetCollection else {
            return
        }
        
        //HAssetCollection.fetchTopLevelUserCollectionsWithOptions()
        
        let options = PHFetchOptions()
        options.includeAssetSourceTypes = .TypeUserLibrary
        options.predicate = NSPredicate(format: "mediaType == %@", NSNumber(integer: PHAssetMediaType.Image.rawValue))
        
        let imageManager = PHCachingImageManager()
        
        let assets = PHAsset.fetchAssetsInAssetCollection(rec, options: options)
        let totalAssetsCount = assets.count
        assets.enumerateObjectsUsingBlock { (object: AnyObject!, count: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            //print("we have assets")
            if object is PHAsset {
                let asset = object as! PHAsset
                
                let imageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
                
                let imageOptions = PHImageRequestOptions()
                imageOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.FastFormat
                //imageOptions.synchronous = true
                
                    
                imageManager.requestImageForAsset(asset, targetSize: imageSize, contentMode: .AspectFill, options: imageOptions, resultHandler: {
                    (image: UIImage?, info: [NSObject : AnyObject]?) -> Void in
                    //print("we have images")
                    if let img = image {
                        self.data.append(MHGalleryItem(image: img))
                    }
                })
            }
            print(count)
            if count >= totalAssetsCount - 1 {
                print("finished loading")
                self.finished = true
                if self.finishedCallback != nil {
                    self.finishedCallback()
                }
            }
        }
    }
    var finished = false
    var finishedCallback: (() -> Void)!
    

}
