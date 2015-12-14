//
//  PostDesignStudioViewModel.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/14/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import MHVideoPhotoGallery

class PostDesignStudioViewModel {
    private var designStudio: DesignStudio?
    
    // TODO REMOVE
    init () {
        for _ in 1...100 {
            self.data.append(MHGalleryItem (URL: "https://placeholdit.imgix.net/~text?txtsize=28&txt=300%C3%97300&w=300&h=300", galleryType: MHGalleryType.Image))
        }
    }
    
    var designStudioTitle: String {
        get { return designStudio?.title ?? "" }
    }
    
    func setDesignStudio(designStudio: DesignStudio) {
        self.designStudio = designStudio
    }
    
    // MARK: - Data
    
    var data = [MHGalleryItem]()
    
    var totalImages: Int {
        return data.count
    }
    
    func getAllGalleryItems() -> [MHGalleryItem] {
        return data
    }
    
    func getGalleryItem(index: Int) -> MHGalleryItem {
        return self.data[index]
    }
}
