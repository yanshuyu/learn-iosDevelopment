//
//  Restaurant.swift
//  foodieApp
//
//  Created by sy on 2019/4/13.
//  Copyright © 2019 sy. All rights reserved.
//

import Foundation


class Restaurant {
    var name: String
    var location: String
    var category: String
    var thumbnailImageName: String
    var isMarked: Bool
    var detailDesc: String
    init(name: String, location: String, category: String, thumbnailImageName: String, isMarked: Bool, description: String ) {
        self.name = name
        self.location = location
        self.category = category
        self.thumbnailImageName = thumbnailImageName
        self.isMarked = isMarked
        self.detailDesc = description
    }
    
    convenience init() {
        self.init(name: "", location: "", category: "", thumbnailImageName: "", isMarked: false, description: "")
    }
}


extension Restaurant: Equatable, CustomStringConvertible {
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        return lhs.name == rhs.name &&
                lhs.location == rhs.location &&
                lhs.category == rhs.category &&
                lhs.thumbnailImageName == rhs.thumbnailImageName &&
                lhs.isMarked == rhs.isMarked
    }
    
    var description: String {
        return "Restaurant Object At Address: \(Unmanaged.passUnretained(self).toOpaque())\n[\n\tname: \(self.name)\n\tlocation: \(self.location)\n\tcategory: \(self.category)\n\tthumbnailImageName: \(self.thumbnailImageName)\n\tisMarked: \(self.isMarked)\n]"
    }
    
}



class RestaurantFactory {
    private init(){
        self.restaurants = []
    }

    // MARK: - RestaurantFactory Singleton
    private static var instance: RestaurantFactory? = nil
   
    static func getInstance() -> RestaurantFactory {
        if RestaurantFactory.instance == nil {
            RestaurantFactory.instance = RestaurantFactory()
        }
        return RestaurantFactory.instance!
    }
    
    
    // MARK: - RestaurantFactory Data Management
    private var restaurants: [Restaurant]
    
    func setRestaurants(_ restaurants: [Restaurant]) -> Void {
        self.restaurants = restaurants
    }
    
    func appendRestaurant(_ restaurant: Restaurant) -> Void {
        self.restaurants.append(restaurant)
    }
    
    func appendRestaurants(_ restaurants: [Restaurant]) -> Void {
        self.restaurants += restaurants
    }
    
    func getRestaurants() -> [Restaurant] {
        return self.restaurants
    }
    
    func getRestaurantAtIndedx(_ index: Int) -> Restaurant? {
        if index >= self.restaurants.count {
            return nil
        }
        
        return self.restaurants[index]
    }
    
    func removeRestaurantAtIndex(_ index: Int) -> Restaurant? {
        return self.restaurants.remove(at: index)
    }
    
    func reset() -> Void {
        self.restaurants = []

    }
    
}
