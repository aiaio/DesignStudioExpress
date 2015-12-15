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
        //HAssetCollection.fetchTopLevelUserCollectionsWithOptions()
        let assetLibrary = ALAssetsLibrary()
        let assetsType : ALAssetsGroupType = Int(ALAssetsGroupAll)
        
        assetLibrary.enumerateGroupsWithTypes(assetsType, usingBlock: { (group: ALAssetsGroup!, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            guard group != nil else {
                return
            }
            
            group.enumerateAssetsUsingBlock({ (asset: ALAsset!, idx, stop) -> Void in
                if asset != nil {
                    if let defaultRep = asset.defaultRepresentation() {
                        self.data.append(MHGalleryItem(URL: defaultRep.url().absoluteString, galleryType: .Image))
                    }
                }
            })
            
        }, failureBlock: nil)
    }
}
