//
//  RestaurantTableViewCell.swift
//  foodieApp
//
//  Created by sy on 2019/4/13.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    @IBOutlet var nameLable: UILabel!;
    @IBOutlet var locationLable: UILabel!;
    @IBOutlet var typeLable: UILabel!;
    @IBOutlet var thumbnailImageView: UIImageView!{
        didSet {
            thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width * 0.15
            thumbnailImageView.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initByData(_ data: Restaurant) -> Void {
        self.nameLable.text = data.name
        self.locationLable.text = data.location
        self.typeLable.text = data.category
        self.thumbnailImageView.image = UIImage(named: data.thumbnailImageName)
        self.accessoryType = data.isMarked ? .checkmark : .none
    }

}
