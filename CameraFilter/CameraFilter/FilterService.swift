//
//  FilterService.swift
//  CameraFilter
//
//  Created by Jhoan Mauricio Vivas Rubiano on 13/05/20.
//  Copyright © 2020 Sennin. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
import RxSwift

class FilterService {
    private var context:CIContext
    
    
    init() {
        self.context = CIContext()
    }
    
    func applyFilter(to inputImage:UIImage)-> Observable<UIImage> {
        //Creating a pure observable without Subjects
        return Observable<UIImage>.create { (observable) -> Disposable in
            self.applyFilter(to: inputImage) { (imageFiltered) in
                observable.onNext(imageFiltered)
            }
            //Create Disposable Instace for the observer, to avoid retantion cycle
            return Disposables.create()
        }
    }
    
    //TODO: Review CoreImage Framework
    private func applyFilter(to inputImage:UIImage, completion: @escaping ((UIImage)->())){
        let filter = CIFilter(name:"CIHatchedScreen")!
        filter.setValue(5.0, forKey: kCIInputWidthKey)
        
        if let sourceImage = CIImage(image: inputImage) {
            filter.setValue(sourceImage, forKey: kCIInputImageKey)
            
            if let cgimg = self.context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent){
                let processedImg =  UIImage(cgImage: cgimg, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                completion(processedImg)
            }
        }
        
    }
}
