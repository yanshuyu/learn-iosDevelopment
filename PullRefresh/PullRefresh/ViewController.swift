//
//  ViewController.swift
//  PullRefresh
//
//  Created by Gabriel Theodoropoulos on 6/6/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tblDemo: UITableView!
    
    var dataArray = ["one", "two", "three", "four", "five"]
    var refreshControl: UIRefreshControl!
    var refreshLables: [UILabel]!
    
    let textColors = [UIColor.green, UIColor.yellow, UIColor.orange, UIColor.cyan,  UIColor.magenta, UIColor.purple, UIColor.blue]
    var currentRotateIndex = 0
    var shouldContinueRefreshAnimation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //let atrributeDict = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: UIFont.systemFontSize)]
        self.refreshControl = UIRefreshControl()
        self.tblDemo.addSubview(self.refreshControl)
        self.refreshControl.backgroundColor = UIColor.clear
        //self.refreshControl.attributedTitle = NSAttributedString(string: "refreshing...", attributes: atrributeDict)
        self.refreshControl.addTarget(self, action: #selector(performRefresh), for: .valueChanged)
        self.refreshLables = loadCustomRefreshControlContents()
       
        
        self.tblDemo.dataSource = self
        self.tblDemo.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadCustomRefreshControlContents() -> [UILabel] {
        var lables: [UILabel] = []
        let nibContents = Bundle.main.loadNibNamed("RefreshContents", owner: self, options: nil)
        let customRefreshView = nibContents![0] as! UIView
        customRefreshView.frame = self.refreshControl.bounds
        for i in 1...customRefreshView.subviews.count {
            let lable = customRefreshView.viewWithTag(i)! as! UILabel
            lables.append(lable)
        }
        self.refreshControl.addSubview(customRefreshView)
        return lables
    }
    
    @objc private func performRefresh() {
        print("refreshing...")
        self.shouldContinueRefreshAnimation = true
        beginRefreshAnimation()
        
        let delay = Double.random(in: 4...10)
        let timer = Timer(timeInterval: delay, repeats: false) { (timer) in
            self.refreshControl.endRefreshing()
            self.endRefreshAnimation()
            timer.invalidate()
            print("refresh finish.")
        }
        RunLoop.main.add(timer, forMode: .commonModes)
    }

    private func beginRefreshAnimation() {
        if shouldContinueRefreshAnimation {
            if self.currentRotateIndex < self.refreshLables.count {
                 rotateAndColorLable(lable: self.refreshLables[self.currentRotateIndex]) {
                    if self.shouldContinueRefreshAnimation {
                        self.currentRotateIndex += 1
                        self.beginRefreshAnimation()
                    }
                 }
             } else {
                self.refreshLables.forEach { (lable) in
                    lable.textColor = UIColor.black
                    scaleLable(lable: lable) {
                        if self.shouldContinueRefreshAnimation && self.currentRotateIndex >= self.refreshLables.count {
                            self.currentRotateIndex = 0
                            self.beginRefreshAnimation()
                        }
                    }
                }
             }
        }
    }
    
    private func endRefreshAnimation() {
        self.shouldContinueRefreshAnimation = false
        self.currentRotateIndex = 0
        self.refreshLables.forEach { (lable) in
            lable.transform = CGAffineTransform.identity
            lable.textColor = UIColor.black
        }
    }
    
    private func rotateAndColorLable(lable: UILabel, completion: (()->Void)? ) {
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6) {
                lable.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 0.25)
                lable.textColor = self.textColors[self.currentRotateIndex]
            }
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                lable.transform = CGAffineTransform.identity
                //lable.textColor = UIColor.black
            }
        }) { (finish) in
            completion?()
        }
    }
    
    private func scaleLable(lable: UILabel, completion: (()->Void)? ) {
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                lable.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                lable.transform = CGAffineTransform.identity
            }
        }) { (finish) in
            completion?()
        }
    }

}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblDemo.dequeueReusableCell(withIdentifier: "idCell", for: indexPath)
        cell.textLabel?.text = self.dataArray[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

