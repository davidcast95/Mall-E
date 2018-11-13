//
//  SettingsTableViewController.swift
//  Mall-E
//
//  Created by David Wibisono on 5/21/17.
//  Copyright © 2017 David Wibisono. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var allNotificationSwitch:UISwitch!
    @IBOutlet weak var loginLabel:UILabel!
    
    override func viewDidLoad() {
        allNotificationSwitch.isOn = UserPref.allNotification
        allNotificationSwitch.addTarget(self, action: #selector(UpdateAllNotificationSettings(switch:)), for: .valueChanged)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.section == 1 {
            if UserPref.isLogin {
                if let userProfileVC = storyboard?.instantiateViewController(withIdentifier: "user-profile") {
                    navigationController?.pushViewController(userProfileVC, animated: true)
                }
            } else {
                if let loginVC = storyboard?.instantiateViewController(withIdentifier: "login") {
                    navigationController?.pushViewController(loginVC, animated: true)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserPref.isLogin {
            loginLabel.text = UserPref.email
        } else {
            loginLabel.text = "Login"
        }
    }
    
    @objc func UpdateAllNotificationSettings(switch:UISwitch) {
        UserPref.allNotification = allNotificationSwitch.isOn
    }
    
    @IBAction func ResetPromotion() {
        UserPref.adsSeen = ""
        FIRDatabase.database().reference().child("users/\(UserPref.uid)/adsSeen").setValue("")
    }
}
