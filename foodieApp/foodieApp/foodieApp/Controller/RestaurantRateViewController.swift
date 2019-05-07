//
//  RestaurantRateViewController.swift
//  foodieApp
//
//  Created by sy on 2019/4/20.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class RestaurantRateViewController: UIViewController {
    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var rateButtons: [UIButton]!
    
    
    var restaurant: RestaurantModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for rateButton in self.rateButtons {
            rateButton.alpha = 0
            let translateTransform = CGAffineTransform.init(translationX: 600, y: 0)
            let scaleTransform = CGAffineTransform.init(scaleX: 5.0, y: 5.0)
            let translateAndScaleTransform = scaleTransform.concatenating(translateTransform)
            rateButton.transform = translateAndScaleTransform
        }
        
        let scaleTransform = CGAffineTransform.init(scaleX: 0, y: 0)
        let translateTransform = CGAffineTransform.init(translationX: 0, y: -600)
        let translateAndScaleTransform = scaleTransform.concatenating(translateTransform)
        self.closeButton.transform = translateAndScaleTransform
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let data = self.restaurant, let imageData = data.thumbnailImage {
            self.restaurantImageView.image = UIImage(data: imageData)
        }
        
        // rate buttons animation
        let animDuration = 0.5
        let animInterval = 0.1
        var animDelay = 0.0
        for rateButton in self.rateButtons {
            UIView.animate(withDuration: animDuration, delay: animDelay, options: [], animations: {
                rateButton.alpha = 1
                rateButton.transform = .identity
            }, completion: nil)
            
            animDelay += animInterval
        }
        
        UIView.animate(withDuration: animDuration, animations: {
            self.closeButton.transform = .identity
        }, completion: nil)
    }
    

}
