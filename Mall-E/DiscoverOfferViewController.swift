//
//  DiscoverOfferViewController.swift
//  Mall-E
//
//  Created by David Wibisono on 5/21/17.
//  Copyright © 2017 David Wibisono. All rights reserved.
//

import UIKit

class DiscoverOfferViewController: UIViewController {

    @IBOutlet weak var offerHeight:NSLayoutConstraint!
    @IBOutlet weak var topOffer:NSLayoutConstraint!
    @IBOutlet weak var locationNearbyLabel:UILabel!
    var activeMall:Mall!
    
    override func viewDidAppear(_ animated: Bool) {
        locationNearbyLabel.text = "Pakuwon Mall"
    }
    
    
    
    

}
