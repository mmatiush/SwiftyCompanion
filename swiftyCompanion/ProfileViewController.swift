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
    @IBOutlet weak var skillsTable: UITableView!
    @IBOutlet weak var projectsTable: UITableView!
    
    var json: JSON?

    override func viewDidLoad() {
        super.viewDidLoad()
       
        avatar.layer.borderWidth = 2
        avatar.layer.masksToBounds = true
        avatar.layer.borderColor = UIColor.white.cgColor
        avatar.layer.cornerRadius = avatar.frame.width / 2
        
        skillsTable.layer.cornerRadius = 5
        projectsTable.layer.cornerRadius = 5

    }
    
    func setProfile() {
        
    }

    func setPhoto() {
        
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == skillsTable, let cell = tableView.dequeueReusableCell(withIdentifier: "skillsCell", for: indexPath) as? SkillsTableViewCell {
            cell.skillLabel.text = "Algorithm"
            return cell
        } else if tableView == projectsTable, let cell = tableView.dequeueReusableCell(withIdentifier: "projectsCell", for: indexPath) as? ProjectsTableViewCell {
            cell.projectLabel.text = "Day 01 - 20.0%"
            return cell
        }
        return UITableViewCell()
    }
    
}
