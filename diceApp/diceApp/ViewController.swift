//
//  ViewController.swift
//  diceApp
//
//  Created by sy on 2019/2/23.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var diceImages: [UIImage?] = []
    var diceImageViews: [UIImageView?] = []
    var randomIndex: [Int] = [0,0,0,0]
    
    @IBOutlet weak var diceImageView_1: UIImageView!
    @IBOutlet weak var diceImageView_2: UIImageView!
    @IBOutlet weak var diceImageView_3: UIImageView!
    @IBOutlet weak var diceImageView_4: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        diceImages = [UIImage(named: "dice1"), UIImage(named: "dice2"), UIImage(named: "dice3"), UIImage(named: "dice4"), UIImage(named: "dice5"), UIImage(named: "dice6")]
        diceImageViews = [diceImageView_1, diceImageView_2, diceImageView_3, diceImageView_4]
        
        doRoll()
    }

    @IBAction func onRollButtonDidPress(_ sender: UIButton) {
        doRoll()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        doRoll()
    }
    
    func doRoll()-> Void {
        for (index,_) in randomIndex.enumerated() {
            randomIndex[index] = Int(arc4random_uniform(6))
        }
        print(randomIndex)
        
        for (index, imageView) in diceImageViews.enumerated() {
            imageView?.image = diceImages[randomIndex[index]]
        }
    }
        
}

