//
//  ViewController.swift
//  CameraFilter
//
//  Created by Jhoan Mauricio Vivas Rubiano on 13/05/20.
//  Copyright © 2020 Sennin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
    
}

