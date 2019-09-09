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
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var levelProgressBar: UIProgressView!
    
    
    var json: JSON!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        avatar.layer.borderWidth = 2
        avatar.layer.masksToBounds = true
        avatar.layer.borderColor = UIColor.white.cgColor
        avatar.layer.cornerRadius = avatar.frame.width / 2
        
        levelProgressBar.transform = levelProgressBar.transform.scaledBy(x: 1, y: 3)
        levelProgressBar.layer.cornerRadius = levelProgressBar.frame.height / 2
        levelProgressBar.clipsToBounds = true
        levelProgressBar.layer.sublayers![1].cornerRadius = levelProgressBar.frame.height / 2
        levelProgressBar.subviews[1].clipsToBounds = true
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

        switch tableView {
        case skillsTable:
            return json["cursus_users"][0]["skills"].count
        case projectsTable:
            return json["projects_users"].count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == skillsTable, let cell = tableView.dequeueReusableCell(withIdentifier: "skillsCell", for: indexPath) as? SkillsTableViewCell {
            
            let skillName = json["cursus_users"][0]["skills"][indexPath.row]["name"].string
            let skillLevel = json["cursus_users"][0]["skills"][indexPath.row]["level"].float
            
            if skillName != nil && skillLevel != nil {
                cell.skillLabel.text = skillName! + " - level: " + String(skillLevel!)
            }
            
            return cell
        } else if tableView == projectsTable, let cell = tableView.dequeueReusableCell(withIdentifier: "projectsCell", for: indexPath) as? ProjectsTableViewCell {
            
            let name = json["projects_users"][indexPath.row]["project"]["name"].string
            let mark = json["projects_users"][indexPath.row]["final_mark"].float
            let validated = json["projects_users"][indexPath.row]["validated?"].bool
            
            switch validated {
            case true:
                cell.statusImage.image = #imageLiteral(resourceName: "success")
            case false:
                cell.statusImage.image = #imageLiteral(resourceName: "fail")
            default:
                cell.statusImage.image = #imageLiteral(resourceName: "in_progress")
            }
        
            if name != nil && mark != nil {
                cell.projectLabel.text = name! + " - " + String(mark!).capitalized + "%"
            } else if name != nil {
                cell.projectLabel.text = name! + " - in progress"
            }

            return cell
        }
        return UITableViewCell()
    }
    
}
