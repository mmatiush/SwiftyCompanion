//
//  ProfileViewController.swift
//  swiftyCompanion
//
//  Created by Maksym MATIUSHCHENKO on 8/16/19.
//  Copyright © 2019 Maksym MATIUSHCHENKO. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    
    var json: JSON?

    override func viewDidLoad() {
        super.viewDidLoad()
       
        avatar.layer.borderWidth = 2
        avatar.layer.masksToBounds = true
        avatar.layer.borderColor = UIColor.white.cgColor
        avatar.layer.cornerRadius = avatar.frame.width / 2
        
        backgroundView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)

    }
    
    func setProfile() {
        
    }

    func setPhoto() {
        
    }
    
}
