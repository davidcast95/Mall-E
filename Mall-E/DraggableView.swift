//
//  DraggableView.swift
//  Mall-E
//
//  Created by David Wibisono on 5/25/17.
//  Copyright © 2017 David Wibisono. All rights reserved.
//

import UIKit

class DraggableView: UIVisualEffectView {

    @IBOutlet weak var textViewHeight:NSLayoutConstraint!
    @IBOutlet weak var heightView:NSLayoutConstraint!
    @IBOutlet weak var textView:UITextView!
    var minHeight:CGFloat = 80.0, maxHeight:CGFloat = 200.0
    var contentIsDrag = false
    var lastPoint = CGPoint()
    
    
    func Hide() {
        heightView.constant = 0
    }
    
    func SetContentText(text:String) {
        let height = text.HeightWithConstrainedWidth(width: self.frame.width, font: self.textView.font!)
        textView.text = text
        maxHeight = max(height, minHeight)
        textViewHeight.constant = height
    }
    
    func Show(VC:UIViewController) {
        self.heightView.constant = minHeight
        UIView.animate(withDuration: 2, animations: {
            VC.view.layoutIfNeeded()
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        contentIsDrag = true
        for touch in touches {
            lastPoint = touch.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if contentIsDrag {
            for touch in touches {
                let newPoint = touch.location(in: self)
                let offsetY = lastPoint.y - newPoint.y
                lastPoint = newPoint
                self.heightView.constant += offsetY
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        contentIsDrag = false
        print("ended")
    }



}
