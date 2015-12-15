//
//  PostDesignStudioViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/12/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit
import MHVideoPhotoGallery

class PostDesignStudioViewController: UIViewControllerBase, UICollectionViewDelegate, UICollectionViewDataSource, MHGalleryDataSource,MHGalleryDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let vm = PostDesignStudioViewModel()
    
    let cellIdentifier = "MHMediaPreviewCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.removeLastViewFromNavigation()
                
        self.navigationItem.title = vm.designStudioTitle
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.registerClass(MHMediaPreviewCollectionViewCell.self, forCellWithReuseIdentifier: self.cellIdentifier)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.vm.loadData {
            self.collectionView.reloadData()
        }
    }
    
    // to make back button always lead to the challenges screen
    // remove all Timers and End screens from the nav stack
    private func removeLastViewFromNavigation() {
        let endIndex = (self.navigationController?.viewControllers.endIndex ?? 0) - 1
        if endIndex > 0 {
            let previousVC = self.navigationController?.viewControllers[endIndex-1]
            if previousVC is TimerViewController || previousVC is EndActivityViewController {
                self.navigationController?.viewControllers.removeAtIndex(endIndex-1)
            }
        }
    }

    // MARK: StyledNavigationBar
    
    override func customizeNavBarStyle() {
        super.customizeNavBarStyle()
        
        DesignStudioElementStyles.pinkNavigationBar(self.navigationController!.navigationBar)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.totalImages
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.cellIdentifier, forIndexPath: indexPath) as! MHMediaPreviewCollectionViewCell
        
        cell.thumbnail.contentMode = .ScaleAspectFill
        
        cell.thumbnail.image = nil;
        cell.galleryItem = vm.getGalleryItem(indexPath.row)
        
        return cell;
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MHMediaPreviewCollectionViewCell
        let imageView = cell.thumbnail
        let gallery = MHGalleryController(presentationStyle: .ImageViewerNavigationBarShown)
        gallery.UICustomization.showOverView = false
        gallery.galleryItems = vm.getAllGalleryItems()
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
        return vm.getGalleryItem(index)
    }
    /**
     *  @param galleryController
     *
     *  @return the number of Items you want to Display
     */
    func numberOfItemsInGallery(galleryController: MHGalleryController!) -> Int {
        return vm.totalImages
    }
}
