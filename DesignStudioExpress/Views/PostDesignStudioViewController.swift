//
//  PostDesignStudioViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/12/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit
import MHVideoPhotoGallery

class PostDesignStudioViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MHGalleryDataSource,MHGalleryDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        
        self.collectionView.registerClass(MHMediaPreviewCollectionViewCell.self, forCellWithReuseIdentifier: "MHMediaPreviewCollectionViewCell")
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellIdentifier = "MHMediaPreviewCollectionViewCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! MHMediaPreviewCollectionViewCell
        
        cell.thumbnail.contentMode = .ScaleAspectFill
        
        cell.thumbnail.image = nil;
        cell.galleryItem = MHGalleryItem (URL: "https://placeholdit.imgix.net/~text?txtsize=28&txt=300%C3%97300&w=300&h=300", galleryType: MHGalleryType.Image);
        
        return cell;
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MHMediaPreviewCollectionViewCell
        let imageView = cell.thumbnail
        let gallery = MHGalleryController(presentationStyle: .ImageViewerNavigationBarShown)
        gallery.UICustomization.showOverView = false
        gallery.galleryItems = [MHGalleryItem (URL: "https://placeholdit.imgix.net/~text?txtsize=28&txt=300%C3%97300&w=300&h=300", galleryType: MHGalleryType.Image),MHGalleryItem (URL: "https://placeholdit.imgix.net/~text?txtsize=28&txt=300%C3%97300&w=300&h=300", galleryType: MHGalleryType.Image)]
        gallery.presentingFromImageView = imageView
        gallery.presentationIndex = indexPath.row
        gallery.galleryDelegate = self
        
        
        
        gallery.finishedCallback = { [weak gallery] (currentIndex: Int, image: UIImage!, interactiveTransition: MHTransitionDismissMHGallery!, viewMode: MHGalleryViewMode) -> Void in
            
            let newIndexPath: NSIndexPath = NSIndexPath(forRow: currentIndex, inSection: 0)
            let cellFrame: CGRect = collectionView.collectionViewLayout.layoutAttributesForItemAtIndexPath(newIndexPath)!.frame
            collectionView.scrollRectToVisible(cellFrame, animated: false)
            
            dispatch_async(dispatch_get_main_queue(), {[weak gallery] () -> Void in
                collectionView.reloadItemsAtIndexPaths([newIndexPath])
                collectionView.scrollToItemAtIndexPath(newIndexPath, atScrollPosition: .CenteredHorizontally, animated: false)
                let cell: MHMediaPreviewCollectionViewCell = collectionView.cellForItemAtIndexPath(newIndexPath) as! MHMediaPreviewCollectionViewCell
                
                gallery!.dismissViewControllerAnimated(true, dismissImageView: cell.thumbnail, completion: nil)
            })
        }
        self.presentMHGalleryController(gallery, animated: true, completion: nil)
    }
    
    
    // MARK: - MHGalleryDataSource
    
    func itemForIndex(index: Int) -> MHGalleryItem! {
        
        return MHGalleryItem (URL: "https://placeholdit.imgix.net/~text?txtsize=28&txt=300%C3%97300&w=300&h=300", galleryType: MHGalleryType.Image)
    }
    /**
     *  @param galleryController
     *
     *  @return the number of Items you want to Display
     */
    func numberOfItemsInGallery(galleryController: MHGalleryController!) -> Int {
        return 2
    }
}
