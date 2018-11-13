//
//  UserProfileTableViewController.swift
//  Mall-E
//
//  Created by David Wibisono on 6/8/17.
//  Copyright © 2017 David Wibisono. All rights reserved.
//

import UIKit

class UserProfileTableViewController: UITableViewController {

    @IBOutlet weak var email:UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "User Profile"
    }
    
    @IBAction func LogoutTapped(sender:UIButton) {
        UserPref.Reset()
    }

}
