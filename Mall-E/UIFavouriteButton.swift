//
//  UIFavouriteButton.swift
//  Mall-E
//
//  Created by David Wibisono on 11/28/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class UIFavouriteButton: UIButton {
    var product:Product!
    var store:Store!
    
    func Setup(product:Product,store:Store) {
        self.store = store
        self.product = product
        setImage(#imageLiteral(resourceName: "favourite"), for: .selected)
        setImage(#imageLiteral(resourceName: "unfavourite"), for: .normal)
        imageView?.contentMode = .scaleAspectFill
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isSelected = !self.isSelected
        product.favourite = self.isSelected
        let fav = Favourite()
        fav.product = product
        fav.store = store
        if isSelected {
            Model.favourites.append(fav)
        } else {
            var i = 0
            for favo in Model.favourites {
                if favo.product.name == product.name {
                    Model.favourites.remove(at: i)
                }
                i+=1
            }
        }
    }
}
