//
//  RoundTextView.swift
//  foodieApp
//
//  Created by sy on 2019/4/25.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

@IBDesignable
class RoundTextView: UITextView {
    
    @IBInspectable
    var roundRadius: CGFloat = 4
   
    @IBInspectable
    var fillColor: UIColor = UIColor.white
    
    @IBInspectable
    var strokeColor: UIColor = UIColor.lightGray
    
    override func draw(_ rect: CGRect) {
        let roundRect = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.roundRadius)
        self.fillColor.setFill()
        self.strokeColor.setStroke()
        roundRect.addClip()
        roundRect.fill()
        roundRect.stroke()
    }

}
