//
//  WalkthroughViewController.swift
//  foodieApp
//
//  Created by sy on 2019/5/14.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    weak var walkthroughPageViewController: WalkthroughPageViewController? = nil
    var nextButtonToDismiss = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destViewController = segue.destination as? WalkthroughPageViewController {
            self.walkthroughPageViewController = destViewController
            self.walkthroughPageViewController?.walkthroughDelegate = self
        }
    }

    
    @IBAction func onNextButtonClick(_ sender: UIButton) {
        if self.nextButtonToDismiss {
            UserDefaults.standard.set(true, forKey: "hasCompletedWalkthrough")
            dismiss(animated: true, completion: nil)
            return
        }
        
        self.walkthroughPageViewController?.forwardPage()
        self.nextButtonToDismiss = self.walkthroughPageViewController?.isLastPage ?? false
        updateViewForPage(atIndex: self.walkthroughPageViewController?.currentPageIndex ?? 0, isLastPage: self.walkthroughPageViewController?.isLastPage ?? false)
    }
    
    @IBAction func onSkipButtonClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateViewForPage(atIndex index: Int, isLastPage: Bool) -> Void {
        self.pageControl.currentPage = index
        self.nextButton.setTitle(isLastPage ? "Get Started" : "Next", for: .normal)
        self.skipButton.isHidden = isLastPage
    }
}


extension WalkthroughViewController: WalkthroughPageViewControllerDelegate {
    func walkthroughPageView(_ pageViewController: WalkthroughPageViewController, didWalkThrough atIndex: Int) {
        updateViewForPage(atIndex: pageViewController.currentPageIndex, isLastPage: pageViewController.isLastPage)
    }
    
}
