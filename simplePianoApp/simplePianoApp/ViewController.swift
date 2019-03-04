//
//  ViewController.swift
//  simplePianoApp
//
//  Created by sy on 2019/3/4.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func onToneKeyPressed(_ sender: UIButton) {
        print("press on button with tag: \(sender.tag)")
        playToneWithTag(tag: sender.tag)
    }
    
    func playToneWithTag(tag: Int) -> Void {
        let soundName = "note\(tag)"
        let ext = "wav"
        let soundRrl = Bundle.main.url(forResource: soundName, withExtension: ext)
        if soundRrl == nil {
            print("soundRul \"\(soundName).\(ext)\" is not exist!")
            return
        }
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: soundRrl!)
            self.audioPlayer.play()
        } catch {
            print(error)
        }
    }
    
}

