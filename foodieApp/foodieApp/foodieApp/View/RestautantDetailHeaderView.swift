//
//  RestautantDetailHeaderView.swift
//  foodieApp
//
//  Created by sy on 2019/4/15.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class RestautantDetailHeaderView: UIView {
    @IBOutlet var nameLable: UILabel!
    @IBOutlet var typeLable: UILabel!
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var markButton: UIButton!
    @IBOutlet var rateImageView: UIImageView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func initByData(_ restaurantData: Restaurant) -> Void {
        self.nameLable.text = restaurantData.name
        self.typeLable.text = restaurantData.category
        self.headerImageView.image = UIImage(named: restaurantData.thumbnailImageName)
        self.markButton.tintColor = restaurantData.isMarked ? #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        if let rateImage = restaurantData.rateImage {
            self.rateImageView.image = UIImage(named: rateImage)
        }
    }
    
    
}
