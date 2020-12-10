//
//  ViewController.swift
//  Homework 6.1
//
//  Created by Stas on 07.12.2020.
//

import UIKit

class ViewController: UIViewController {

    var tmpImage = UIImage()
    @IBOutlet weak var fullImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fullImage.image = tmpImage
    }

}

