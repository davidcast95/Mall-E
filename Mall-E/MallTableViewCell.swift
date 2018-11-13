//
//  MallTableViewCell.swift
//  Mall-E
//
//  Created by David Wibisono on 9/28/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class MallTableViewCell: CardTableViewCell {
    
    @IBOutlet weak var mallLocation: UILabel!
    @IBOutlet weak var mallName: UILabel!
    @IBOutlet weak var mallImage: UIImageView!
    
    override func Setup() {
        super.Setup()
        let shadowPath = UIBezierPath(roundedRect: mallImage.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = shadowPath.cgPath
        mallImage.layer.mask = maskLayer
    }

}
