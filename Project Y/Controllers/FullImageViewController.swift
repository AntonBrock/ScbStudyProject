//
//  FullImageViewController.swift
//  Project Y
//
//  Created by Admin on 11.09.2020.
//  Copyright © 2020 Anton Dobrynin. All rights reserved.
//

import UIKit

class FullImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView?.image = image
    }
}
