//
//  OfferTableViewCell.swift
//  Mall-E
//
//  Created by David Wibisono on 9/28/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class OfferTableViewCell: UITableViewCell {

    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeLocation: UILabel!
    @IBOutlet weak var storeOfferImage: UIImageView!
    @IBOutlet weak var productDiscount: UILabel!
    @IBOutlet weak var productPriceRange: UILabel!
    @IBOutlet weak var productFavoriteButtons: UIFavouriteButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
