//
//  PhotosCollectionViewController.swift
//  CameraFilter
//
//  Created by Jhoan Mauricio Vivas Rubiano on 13/05/20.
//  Copyright © 2020 Sennin. All rights reserved.
//

import Foundation
import UIKit
import Photos
import RxSwift

class PhotosCollectionViewController: UICollectionViewController{
    
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    //making public the observable
    var selectedPhoto: Observable<UIImage> {
        return selectedPhotoSubject.asObserver()
    }
    
    private var libraryImages = [PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populatePhotos()
    }
    
    private func populatePhotos(){
        PHPhotoLibrary.requestAuthorization { [weak self] (status) in
            if status == .authorized {
                // acces to the photo library data
                let assets = PHAsset.fetchAssets(with: .image, options: nil)
                assets.enumerateObjects { (object, counter, stopPointer) in
                    self?.libraryImages.append(object)
                }
                //Used to rever the order : lasted image
                self?.libraryImages.reverse()
                //call to rebuild the UI interface with the data
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }else{
                
            }
        }
    }
    
    //Overrides parent methods required.
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.libraryImages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("PhotoCollectionViewCell was not foud")
        }
        let asset = self.libraryImages[indexPath.row]
        
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: 150, height: 150), contentMode: .aspectFit, options: nil) { (image, info) in
            DispatchQueue.main.async {
                cell.cellImageview.image = image
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAsset = self.libraryImages[indexPath.row]
        let manager = PHImageManager.default()
        manager.requestImage(for: selectedAsset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { [weak self] (image, info) in
            //This method reponse twice, in the first event this return the thumbnail image and it's necessary avoid it.
            guard let info = info else {
                return
            }
            
            let isDegreatedImage = info["PHImageResultIsDegradedKey"] as! Bool
            
            if !isDegreatedImage {
                if let image = image {
                    self?.selectedPhotoSubject.onNext(image)
                    self?.dismiss(animated: true
                        , completion: nil)
                }
            }
            
        }
    }
    
}
