//
//  WalkthroughPageViewController.swift
//  foodieApp
//
//  Created by sy on 2019/5/14.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

protocol WalkthroughPageViewControllerDelegate: class {
    func walkthroughPageView(_ pageViewController: WalkthroughPageViewController, didWalkThrough atIndex: Int) -> Void
}


class WalkthroughPageViewController: UIPageViewController {
    weak var walkthroughDelegate: WalkthroughPageViewControllerDelegate? = nil
    
    var isLastPage = false
    var currentPageIndex = 0
    
    private var images: [String] = ["onboarding-1", "onboarding-2", "onboarding-3"]
    private var headingTexts: [String] = ["CREATE YOUR OWN FOOD GUIDE", "SHOW YOU THE LOCATION", "DISCOVER GRATE RESTAURANTS"]
    private var subHeadingTexts: [String] = ["pin your favorite restaurants and creare your own food guide",
                                     "search and locate your favorite restaurant on map",
                                     "find restutants shared by your friends or other foodies"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        if let startingContentViewController = pageContentViewController(forIndex: 0) {
            setViewControllers([startingContentViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    
    func pageContentViewController(forIndex index: Int) -> WalkthrougPageContentViewController? {
        if (index < 0 || index >= headingTexts.count) {
            return nil
        }
        
        let walkthroughSceneStoryboard = UIStoryboard(name: "WalkThroughScreen", bundle: nil)
        if let viewController = walkthroughSceneStoryboard.instantiateViewController(withIdentifier: "WalkthrougPageContentViewController") as? WalkthrougPageContentViewController {
            viewController.pageIndex = index
            viewController.imageName = images[index]
            viewController.headingText = headingTexts[index]
            viewController.subHeadingText = subHeadingTexts[index]
            
            return viewController
        }
        
        return nil
    }
    
    
    func forwardPage() {
        self.currentPageIndex += 1
        self.isLastPage = self.currentPageIndex >= self.headingTexts.count - 1
        if let nextViewController = pageContentViewController(forIndex: self.currentPageIndex) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }

}


extension WalkthroughPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? WalkthrougPageContentViewController {
            let index = currentViewController.pageIndex - 1
            return pageContentViewController(forIndex: index)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? WalkthrougPageContentViewController {
            let index = currentViewController.pageIndex + 1
            return pageContentViewController(forIndex: index)
        }
        
        return nil
    }
}


extension WalkthroughPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentPageContentViewController = self.viewControllers?.first as? WalkthrougPageContentViewController {
                self.currentPageIndex = currentPageContentViewController.pageIndex
                self.isLastPage = self.currentPageIndex >= self.headingTexts.count - 1
                self.walkthroughDelegate?.walkthroughPageView(self, didWalkThrough: self.currentPageIndex)
            }
        }
    }

}
