//
//  ChangePasswordTableViewController.swift
//  Mall-E
//
//  Created by David Wibisono on 6/8/17.
//  Copyright © 2017 David Wibisono. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChangePasswordTableViewController: UITableViewController {

    @IBOutlet weak var oldPasswordTextField:UITextField!
    @IBOutlet weak var newPasswordTextField:UITextField!
    @IBOutlet weak var confirmPasswordTextField:UITextField!
    let loadingUpdate = UIAlertController(title: "Updating password...", message: "", preferredStyle: .alert)
    
    @IBAction func SaveTapped(sender:UIButton) {
        self.view.endEditing(true)
        if newPasswordTextField.text != "" && confirmPasswordTextField.text != "" && newPasswordTextField.text == confirmPasswordTextField.text {
            self.present(loadingUpdate, animated: true, completion: nil)
            if let user = FIRAuth.auth()?.currentUser {
                user.updatePassword(newPasswordTextField.text!, completion: {(error) in
                    self.loadingUpdate.dismiss(animated: true, completion: nil)
                    if ((error) != nil) {
                        if let errorDesc = error?.localizedDescription {
                            let emptyWarning = UIAlertController(title: "Update password error!", message: errorDesc, preferredStyle: .alert)
                            emptyWarning.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(emptyWarning, animated: true, completion: nil)
                        }
                    } else {
                        let emptyWarning = UIAlertController(title: "Password updated!", message: "", preferredStyle: .alert)
                        emptyWarning.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(emptyWarning, animated: true, completion: nil)
                    }
                })
            }
        } else {
            let emptyWarning = UIAlertController(title: "Invalid password!", message: "", preferredStyle: .alert)
            emptyWarning.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(emptyWarning, animated: true, completion: nil)
        }
    }
    
}
