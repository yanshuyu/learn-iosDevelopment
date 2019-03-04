//
//  ViewController.swift
//  Magic-8-Ball
//
//  Created by sy on 2019/3/3.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var answerImageView: UIImageView!
    var answerImages: [UIImage?] = []
    
    func rollAnswer() -> Void {
        let idx = Int.random(in: 0 ... 4)
        print("random index: \(idx)")
        answerImageView.image = answerImages[idx]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        answerImages = [UIImage(named: "ball1"), UIImage(named: "ball2"), UIImage(named: "ball3"), UIImage(named: "ball4"), UIImage(named: "ball5")]
        rollAnswer()
    }
    
    @IBAction func onAskButtonPressed(_ sender: UIButton) {
        rollAnswer()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAnswer()
    }
}

