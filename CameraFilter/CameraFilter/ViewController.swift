//
//  ViewController.swift
//  CameraFilter
//
//  Created by Jhoan Mauricio Vivas Rubiano on 13/05/20.
//  Copyright © 2020 Sennin. All rights reserved.
//

import UIKit
import RxSwift
class ViewController: UIViewController {
    
    @IBOutlet weak var imageToFilter:UIImageView!
    @IBOutlet weak var filterBtn:UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI(){
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            //Todo: implement large titles
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Select the Controller based on the navigation of the UI
        guard let nvController = segue.destination as? UINavigationController, let photoController = nvController.viewControllers.first as? PhotosCollectionViewController else {
            fatalError("there is not segue to Photos")
        }
        
        photoController.selectedPhoto.subscribe(onNext: { [weak self] (imageSelected) in
            DispatchQueue.main.async {
                self?.updateUI(with: imageSelected)
            }
        }).disposed(by: disposeBag)
        
    }
    
    private func updateUI(with Image: UIImage){
        self.imageToFilter.image = Image
        self.filterBtn.isHidden = false
        
    }
    
    @IBAction func applyFilterOnButtonTap(){
        guard let image = self.imageToFilter.image else {
            return
        }
        FilterService().applyFilter(to: image).subscribe(onNext: { [weak self](imageFiltered) in
            DispatchQueue.main.async {
                self?.updateUI(with: imageFiltered)
            }
        }).disposed(by: disposeBag)
    }
}

