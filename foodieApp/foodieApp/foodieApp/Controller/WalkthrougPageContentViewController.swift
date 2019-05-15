//
//  WalkthrougPageContentViewController.swift
//  foodieApp
//
//  Created by sy on 2019/5/14.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class WalkthrougPageContentViewController: UIViewController {
    var imageName = ""
    var headingText = ""
    var subHeadingText = ""
    var pageIndex = 0
    
    @IBOutlet var imageview: UIImageView!;
    @IBOutlet var headingLabel: UILabel!;
    @IBOutlet var subHeadingLabel: UILabel!;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageview.image = UIImage(named: self.imageName)
        self.headingLabel.text = self.headingText
        self.headingLabel.numberOfLines = 0
        self.subHeadingLabel.text = self.subHeadingText
        self.subHeadingLabel.numberOfLines = 0
    }

}
