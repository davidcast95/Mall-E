//
//  NearbyOfferTableViewCell.swift
//  Mall-E
//
//  Created by David Wibisono on 6/18/17.
//  Copyright © 2017 David Wibisono. All rights reserved.
//

import UIKit

class NearbyOfferTableViewCell: CardTableViewCell {

    @IBOutlet weak var featureImage: UIImageView!
    @IBOutlet weak var titleTextView: UILabel!
    @IBOutlet weak var titleTextHeight: NSLayoutConstraint!
    @IBOutlet weak var descTextView: UITextView!
    var nearbyOffer:NearbyOffer?
    let defaultHeaderDescHeight:CGFloat = 25
    let defaultDescHeight:CGFloat = 63
    
    func Setup(nearbyOffer:NearbyOffer) {
        Setup()
        let shadowPath = UIBezierPath(roundedRect: featureImage.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = shadowPath.cgPath
        featureImage.layer.mask = maskLayer
        self.nearbyOffer = nearbyOffer
        featureImage.backgroundColor = nearbyOffer.bg_color
        featureImage.image = nil
        if let img = nearbyOffer.feature_image {
            featureImage.image = img
        } else {
            featureImage.DownloadImageFromStorage(link: (nearbyOffer.image_link), completion: {(image) in
                self.nearbyOffer?.feature_image = image
            })
        }
        
        titleTextView.text = nearbyOffer.title
        descTextView.text = nearbyOffer.desc
        let descHeight = nearbyOffer.desc.HeightWithConstrainedWidth(width: self.frame.width, font: descTextView.font!)
        titleTextHeight.constant = descHeight + defaultHeaderDescHeight + 10
        
    }
    
    
}
