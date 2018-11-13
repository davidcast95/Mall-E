//
//  OfferViewController.swift
//  Mall-E
//
//  Created by David Wibisono on 5/21/17.
//  Copyright © 2017 David Wibisono. All rights reserved.
//

import UIKit
import FirebaseDatabase

class OfferViewController: UIViewController {

    var maxHeight = 0
    @IBOutlet weak var topHeaderHeight:NSLayoutConstraint!
    @IBOutlet weak var featureImage:UIImageView!
    @IBOutlet weak var contentView:DraggableView!
    
    var isContentReady = false
    var contentIsDrag = false
    
    var lastPoint = CGPoint()
    
    var UUID:String = ""
    var ref:FIRDatabaseReference!
    var error = false
    var beacons:[Beacon] = []
    var tabBarVC:TabBarViewController!
    
    
    override func viewDidLoad() {
        
        ref = FIRDatabase.database().reference()
        if beacons.count == 0 {
            error = true
        } else {
            featureImage.DownloadImageFromStorage(link: "offers/"+UUID+"/\(beacons[0].majorMinor).jpg", completion: {(img) in
                self.contentView.Show(VC: self)
            })
            
            if !UserPref.adsSeen.contains("\(beacons[0].majorMinor)") {
                UserPref.adsSeen.append("\(beacons[0].majorMinor) ")
            }
            if UserPref.isLogin {
                ref.child("users").child(UserPref.uid).setValue(["adsSeen":UserPref.adsSeen])
            } else if UserPref.guest_id != "" {
                ref.child("guests").child(UserPref.guest_id).setValue(["adsSeen":UserPref.adsSeen])
            } else {
                UserPref.guest_id = ref.childByAutoId().key
                ref.child("guests").child(UserPref.guest_id).setValue(["adsSeen":UserPref.adsSeen])
            }
        }
        contentView.Hide()
        FetchContent()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if error {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func DoneTapped(sender:UIButton) {
        tabBarVC.offerIsActive = false
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        contentIsDrag = true
        for touch in touches {
            lastPoint = touch.location(in: self.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if contentIsDrag && isContentReady {
            for touch in touches {
                let newPoint = touch.location(in: self.view)
                let offsetY = lastPoint.y - newPoint.y
                
                let percentage = (contentView.frame.height + offsetY) / contentView.maxHeight
                if percentage > 1.2 {
                    contentView.heightView.constant += (offsetY / percentage) * 0.1
                } else if percentage >= 0 {
                    contentView.heightView.constant += offsetY
                }
                lastPoint = newPoint
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isContentReady {
            contentIsDrag = false
            let percentage = (contentView.frame.height) / contentView.maxHeight
            if percentage > 0.75 {
                self.contentView.heightView.constant = self.contentView.maxHeight * 1.2
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.layoutIfNeeded()
                })
            } else {
                self.contentView.heightView.constant = self.contentView.minHeight
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func FetchContent() {
        isContentReady = true
        for beacon in beacons {
            ref.child("offers/"+UUID+"/beacons/"+beacon.majorMinor).observeSingleEvent(of: .value, with: { (snapshot) in
                let offer = snapshot.value as? NSDictionary
                beacon.content = offer?.value(forKey: "content") as? String ?? ""
                self.contentView.SetContentText(text: beacon.content)
            })
        }
        
    }
        
    
}
