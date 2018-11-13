//
//  LoginTableViewController.swift
//  Mall-E
//
//  Created by David Wibisono on 5/21/17.
//  Copyright © 2017 David Wibisono. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class LoginTableViewController: UITableViewController {

    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    @IBOutlet weak var loginButton:UIButton!
    
    var ref:FIRDatabaseReference!
    let loadingLogin = UIAlertController(title: "Login...", message: "", preferredStyle: .alert)
    
    override func viewWillAppear(_ animated: Bool) {
        if UserPref.isLogin {
            title = "Profile"
            emailTextField.text = UserPref.email
            passwordTextField.isEnabled = false
            loginButton.setTitle("Logout", for: .normal)
        } else {
            title = "Login"
            loginButton.setTitle("Login", for: .normal)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            emailTextField.becomeFirstResponder()
        }
        if indexPath.section == 0 && indexPath.row == 1 {
            passwordTextField.becomeFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        ref = FIRDatabase.database().reference()
    }
    
    @IBAction func LoginTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if !UserPref.isLogin {
            if emailTextField.text == "" || passwordTextField.text == "" {
                let emptyWarning = UIAlertController(title: "Login error!", message: "Email or password cannot be empty", preferredStyle: .alert)
                emptyWarning.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(emptyWarning, animated: true, completion: nil)
            } else {
                self.present(loadingLogin, animated: true, completion: nil)
                FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                    self.loadingLogin.dismiss(animated: true, completion: nil)
                    if ((error) != nil) {
                        if let errorDesc = error?.localizedDescription {
                            if errorDesc.contains("no user") {
                                let emptyWarning = UIAlertController(title: "Oh, uh!", message: "It seems this email has not been registered, Are you want to sign this up?", preferredStyle: .alert)
                                emptyWarning.addAction(UIAlertAction(title: "Sign me up", style: .default, handler: { _ in
                                    self.SignUpFirebase(email: self.emailTextField.text!, password: self.passwordTextField.text!)
                                }))
                                emptyWarning.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                                self.present(emptyWarning, animated: true, completion: nil)
                            } else {
                                let emptyWarning = UIAlertController(title: "Login error!", message: errorDesc, preferredStyle: .alert)
                                emptyWarning.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                self.present(emptyWarning, animated: true, completion: nil)
                            }
                            
                            
                            
                        }
                        
                        
                    } else {
                        if let uid = user?.uid {
                            self.ref.child("users").child(uid).child("isLogin").setValue(true)
                            self.ref.child("users").child(uid).observe(.value, with: {
                                (snapshot) in
                                if let user = snapshot.value as? NSDictionary {
                                   UserPref.adsSeen = user.value(forKey: "adsSeen") as? String ?? ""
                                }
                            })
                            
                            
                        }
                        if let us = user {
                            UserPref.isLogin = true
                            UserPref.uid = us.uid
                            UserPref.email = us.email ?? ""
                            UserPref.photoURL = us.photoURL
                            us.getTokenWithCompletion({ (token, error) in
                                if let token = token {
                                    UserPref.token = token
                                }
                            })
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                })
            }
        } else {
            UserPref.Reset()
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func SignUpFirebase(email:String, password:String) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if (error == nil) {
                let emailWarning = UIAlertController(title: "Sign up success!", message: "Please look up the email for verification code!", preferredStyle: .alert)
                emailWarning.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                if let uid = user?.uid {
                    self.ref.child("users").child(uid).setValue([
                        "isLogin":true
                        ])
                }
                
                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (_user, _error) in
                    if let us = _user {
                        UserPref.isLogin = true
                        UserPref.uid = us.uid
                        UserPref.email = us.email ?? ""
                        UserPref.photoURL = us.photoURL
                        us.getTokenWithCompletion({ (token, error) in
                            if let token = token {
                                UserPref.token = token
                            }
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                })
            } else {
                let errorWarning = UIAlertController(title: "Sign up error!", message: error?.localizedDescription, preferredStyle: .alert)
                errorWarning.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                    self.SignUpFirebase(email: email, password: password)
                }))
                errorWarning.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
        })
    }

    
}
