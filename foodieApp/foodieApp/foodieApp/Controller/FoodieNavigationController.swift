//
//  FoodieNavigationController.swift
//  foodieApp
//
//  Created by sy on 2019/4/17.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit


class FoodieNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Status bar Style Customizing
    // Using Individual View Controller preferredStatusBarStyle Instead of The UINavigation Controller
    // preferredStatusBarStyle
    
     open override var preferredStatusBarStyle: UIStatusBarStyle{
        return topViewController?.preferredStatusBarStyle ?? .default
    }

}
