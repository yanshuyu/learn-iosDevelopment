//
//  RestaurantImageViewerController.swift
//  foodieApp
//
//  Created by sy on 2019/5/17.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class RestaurantImageViewerController: UIViewController {
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var restaurantData: RestaurantModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth.union(
        UIView.AutoresizingMask.flexibleHeight)
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.scrollView.delegate = self

        if let data = self.restaurantData, let imageData = data.thumbnailImage {
            self.showImageView.image = UIImage(data: imageData)
            self.scrollView.contentSize = self.showImageView.bounds.size
            self.title = data.name
        }
        setupZoomScale()
        setupGestureRecognizer()
    }
    
    func setupZoomScale() -> Void {
        let imageSize = self.showImageView.bounds.size
        let scrollViewSize = self.scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageSize.width
        let heightScale = scrollViewSize.height / imageSize.height
        
        let minScale = min(widthScale, heightScale)
        self.scrollView.minimumZoomScale = minScale
        self.scrollView.maximumZoomScale = max(2.0, minScale + 1)
        self.scrollView.zoomScale = minScale
    }
    
    func setupGestureRecognizer() -> Void {
        var doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleDoubleTapGestureRecohnizer(_:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.scrollView.addGestureRecognizer(doubleTapGestureRecognizer)
        
    }
    
    
    func centerImageView() {
        let imageViewSize = self.showImageView.frame.size
        let scrollViewSize = self.scrollView.bounds.size
        
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width)*0.5 : 0
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height)*0.5 : 0
        self.scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupZoomScale()
    }
    
    
    @objc func handleDoubleTapGestureRecohnizer(_ gestureRecognizer: UITapGestureRecognizer) -> Void {
        let zoomScale = self.scrollView.zoomScale > self.scrollView.minimumZoomScale ? self.scrollView.minimumZoomScale : self.scrollView.maximumZoomScale
        self.scrollView.setZoomScale(zoomScale, animated: true)
    }
    
}


extension RestaurantImageViewerController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.showImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImageView()
    }

}
