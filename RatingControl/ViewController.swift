//
//  ViewController.swift
//  RatingControl
//
//  Created by luojie on 16/3/22.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func changeValue(sender: UISlider) {
        ratingLabel.text = sender.value.description
    }

    @IBAction func change(sender: RatingControl) {
        ratingLabel.text = sender.value.description
    }
}

