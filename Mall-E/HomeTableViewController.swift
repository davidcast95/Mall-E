//
//  HomeTableViewController.swift
//  Mall-E
//
//  Created by David Wibisono on 9/28/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HomeTableViewController: CardTableViewController, UISearchBarDelegate {
    
    var db:FIRDatabaseReference!
    
    let defaultNearbyOfferCellHeight:CGFloat = 457
    let defaultDescHeight:CGFloat = 88
    let defaultDescFontSize:CGFloat = 14
    
    override func viewDidLoad() {
        db = FIRDatabase.database().reference()
        FetchNearbyOffer()
        tableView.separatorColor = .clear
    }
    
    //MARK: Table View
    override func NumberOfRows(section: Int) -> Int {
        if section == 0 {
            return Model.nearbyOffer.count
        }
        return 0
    }
    override func HeightForRowAt(indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let i = indexPath.row
        let nearbyOffer = Model.nearbyOffer[i]
        if section == 0 {
            let descHeight = nearbyOffer.desc.HeightWithConstrainedWidth(width: self.view.frame.width - ((8+16)*2), font: UIFont.systemFont(ofSize: defaultDescFontSize))
            return defaultNearbyOfferCellHeight + (descHeight - defaultDescHeight) + 10
        }
        return 0
    }
    
    override func CellForRowAt(indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let nearbyOffer = Model.nearbyOffer[indexPath.row]
        if section == 0 {
            if let nearbyCell = tableView.dequeueReusableCell(withIdentifier: "nearby-offer-cell") as? NearbyOfferTableViewCell {
                nearbyCell.Setup(nearbyOffer: nearbyOffer)
                return nearbyCell
            }
        }
        return UITableViewCell()
    }
    
    //MARK: Conectivity
    func FetchNearbyOffer() {
        isLoading = true
        db.child("offers").observeSingleEvent(of: .value, with: { (snapshot) in
            if let offers = snapshot.value as? NSDictionary {
                for offer in offers {
                    if let offerDict = offer.value as? NSDictionary {
                        if let nearbyDict = offerDict.value(forKey: "nearby") as? NSDictionary {
                            for nearbyOfferValue in nearbyDict {
                                let nearbyOffer = NearbyOffer()
                                nearbyOffer.id = nearbyOfferValue.key as? String ?? ""
                                if let nearbyOfferDict = nearbyOfferValue.value as? NSDictionary {
                                    nearbyOffer.Setup(dict: nearbyOfferDict)
                                    Model.nearbyOffer.append(nearbyOffer)
                                }
                            }
                            
                        }
                    }
                }
                
                if Model.nearbyOffer.count > 0 {
                    self.isLoading = false
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
                
            }
        })
    }

}
