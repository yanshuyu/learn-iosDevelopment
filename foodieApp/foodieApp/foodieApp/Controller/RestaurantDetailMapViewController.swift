//
//  RestaurantDetailMapViewController.swift
//  foodieApp
//
//  Created by sy on 2019/4/18.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailMapViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    
    var restaurantData: Restaurant? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.mapView.showsTraffic = true
        self.mapView.showsCompass = true
        self.mapView.showsScale = true
        self.navigationItem.title = " "
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let restaurantData = self.restaurantData {
            let (success, msg) = self.zoomToAnnotaion(toRestaurant: restaurantData)
            if !success {
                print("RestaurantDetailMapViewController.zoomToAnnotaionByLocation() Failed!  Location: \(restaurantData.location)   Error: \(msg!)")
            }
        }
    }
    

    
    
    func zoomToAnnotaion(toRestaurant restautantData: Restaurant) -> (Bool, String?) {
        var success = true
        var msg: String? = nil
        
        let gocoder = CLGeocoder()
        gocoder.geocodeAddressString(restautantData.location) { (placeMarks, error) in
            if let unwrapError = error {
                success = false
                msg = unwrapError.localizedDescription
            }
            
            if let unwrapPlaceMarks = placeMarks {
                if unwrapPlaceMarks.count > 0 {
                    let annotaion = MKPointAnnotation()
                    annotaion.coordinate = (unwrapPlaceMarks[0].location?.coordinate)!
                    annotaion.title = restautantData.name
                    annotaion.subtitle = restautantData.category
                    
                    //self.mapView.addAnnotation(annotaion)
                    self.mapView.showAnnotations([annotaion], animated: true)
                    self.mapView.selectAnnotation(annotaion, animated: true)
                }
                
                success = false
                msg = "Unkonwed Error"
            }
        }
        
        return (success, msg)
    }
    

}


// MARK: - Annation Customzing

extension RestaurantDetailMapViewController: MKMapViewDelegate {
    
     public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // User Current Location Annation, Use Default
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        // Custom Annation Marker
        let iditifyStr = "BlueAnnotationMark"
        var cacheAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: iditifyStr) as? MKMarkerAnnotationView
        if cacheAnnotationView == nil {
            cacheAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: iditifyStr)
        }
        
        cacheAnnotationView?.markerTintColor = UIColor.blue
        cacheAnnotationView?.glyphText = "😋"
        
        
        return  cacheAnnotationView
    }
    
    
}
