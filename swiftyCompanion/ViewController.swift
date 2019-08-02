//
//  ViewController.swift
//  swiftyCompanion
//
//  Created by Maksym MATIUSHCHENKO on 7/29/19.
//  Copyright © 2019 Maksym MATIUSHCHENKO. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBInspectable
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchField: UITextField!

    
    @IBAction func search(_ sender: UIButton) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.layer.cornerRadius = searchField.layer.cornerRadius
    }
}
