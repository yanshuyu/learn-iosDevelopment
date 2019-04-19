//
//  RestaurantDetailThumbnailMapCellTableViewCell.swift
//  foodieApp
//
//  Created by sy on 2019/4/18.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailThumbnailMapCell: UITableViewCell {
    @IBOutlet weak var thumbnailMapView: MKMapView!
    
    func initByData(_ data: Restaurant?) -> Void {
        self.thumbnailMapView.layer.cornerRadius = 15
        self.thumbnailMapView.clipsToBounds = true
        if let data = data {
            self.zoomToAnnotationByLocation(data.location)
        }
    }
    
    func zoomToAnnotationByLocation(_ location: String) -> Void {
        let gocoder = CLGeocoder()
        gocoder.geocodeAddressString(location) { (placeMarks, error) in
            if let unwrapError = error {
                print("RestaurantDetailThumbnailMapCell.zoomToAnnotationByLocation() Failed! Error: \(unwrapError.localizedDescription)")
                return
            }
            
            if let unwrapPlaceMarks = placeMarks {
                if unwrapPlaceMarks.count > 0 {
                    let annotationMark = MKPointAnnotation()
                    annotationMark.coordinate = (unwrapPlaceMarks[0].location?.coordinate)!
                    self.thumbnailMapView.addAnnotation(annotationMark)
                    self.thumbnailMapView.setRegion(MKCoordinateRegion(center: annotationMark.coordinate, latitudinalMeters: 500, longitudinalMeters: 500), animated: false)
                }
            }
        }
    }


}
