//
//  RestaurantTableViewController.swift
//  foodieApp
//
//  Created by sy on 2019/4/12.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {
    var restaurants = [
        Restaurant(name: "barrafina", location: "Hong Kong", category: "Coffe $ Tea Shop", thumbnailImageName: "barrafina", isMarked: false),
        Restaurant(name: "bourkestreetbakery", location: "Hong Kong", category: "Cafe", thumbnailImageName: "bourkestreetbakery", isMarked: false),
        Restaurant(name: "cafedeadend", location: "Hong Kong", category: "Tea House", thumbnailImageName: "cafedeadend", isMarked: false),
        Restaurant(name: "cafeloisl", location: "Hong Kong", category: "Austrian / Causual Drink", thumbnailImageName: "cafeloisl", isMarked: false),
        Restaurant(name: "cafelore", location: "Hong Kong", category: "French", thumbnailImageName: "cafelore", isMarked: false),
        Restaurant(name: "caskpubkitchen", location: "Hong Kong", category: "Bakery", thumbnailImageName: "caskpubkitchen", isMarked: false),
        Restaurant(name: "confessional", location: "Hong Kong", category: "Bakery", thumbnailImageName: "confessional", isMarked: false),
        Restaurant(name: "donostia", location: "Sydney", category: "Chocolate", thumbnailImageName: "donostia", isMarked: false),
        Restaurant(name: "cafedeadend", location: "Sydney", category: "Cafe", thumbnailImageName: "cafedeadend", isMarked: false),
        Restaurant(name: "fiveleaves", location: "Sydney", category: "American / Sea Food", thumbnailImageName: "fiveleaves", isMarked: false),
        Restaurant(name: "forkeerestaurant", location: "New York", category: "American", thumbnailImageName: "forkeerestaurant", isMarked: false),
        Restaurant(name: "grahamavenuemeats", location: "New York", category: "American", thumbnailImageName: "grahamavenuemeats", isMarked: false),
        Restaurant(name: "haighschocolate", location: "New York", category: "Breakfast & Brunch", thumbnailImageName: "haighschocolate", isMarked: false),
        Restaurant(name: "homei", location: "New York", category: "Cafe & Tea", thumbnailImageName: "homei", isMarked: false),
        Restaurant(name: "palominoespresso", location: "New York", category: "Cafe & Tea", thumbnailImageName: "palominoespresso", isMarked: false),
        Restaurant(name: "petiteoyster", location: "New York", category: "American", thumbnailImageName: "petiteoyster", isMarked: false),
        Restaurant(name: "posatelier", location: "New York", category: "American", thumbnailImageName: "posatelier", isMarked: false),
        Restaurant(name: "royaloak", location: "London", category: "Spanish", thumbnailImageName: "royaloak", isMarked: false),
        Restaurant(name: "teakha", location: "London", category: "Spanish", thumbnailImageName: "teakha", isMarked: false),
        Restaurant(name: "traif", location: "unkoLondonnwed", category: "Spanish", thumbnailImageName: "traif", isMarked: false),
        Restaurant(name: "upstate", location: "London", category: "British", thumbnailImageName: "upstate", isMarked: false),
        Restaurant(name: "wafflewolf", location: "London", category: "Thai", thumbnailImageName: "wafflewolf", isMarked: false),
      
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.cellLayoutMarginsFollowReadableWidth = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as! RestaurantTableViewCell
        cell.initByData(restaurants[indexPath.row])

        return cell
    }
 
    // MARK: - Table View Cell Item Selection
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let optionMenu = UIAlertController(title: nil, message: "What Do You Want To Do ?", preferredStyle: .actionSheet)
        let callAction = UIAlertAction(title: "Call 123-000-\(indexPath.row)", style: .default, handler: { (action: UIAlertAction) -> Void in
            let callMenu = UIAlertController(title: nil, message: "Call Feature Now Is No Available", preferredStyle: .alert)
            let cancelCallAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            callMenu.addAction(cancelCallAction)
            self.present(callMenu, animated: true, completion: nil)
        })
        let markAction = UIAlertAction(title: "Mark", style: .default, handler: { (action: UIAlertAction) -> Void in
            let selCell = tableView.cellForRow(at: indexPath)
            selCell?.accessoryType = .checkmark
            tableView.deselectRow(at: indexPath, animated: false)
            self.restaurants[indexPath.row].isMarked = true
        })
        let unmarkAction = UIAlertAction(title: "UnMark", style: .default, handler: { (action: UIAlertAction) -> Void in
            let selCell = tableView.cellForRow(at: indexPath)
            selCell?.accessoryType = .none
            tableView.deselectRow(at: indexPath, animated: false)
            self.restaurants[indexPath.row].isMarked = false
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let finalMarkAction = self.restaurants[indexPath.row].isMarked ? unmarkAction : markAction
        
        optionMenu.addAction(callAction)
        optionMenu.addAction(finalMarkAction)
        optionMenu.addAction(cancelAction)
        
        if let popOver = optionMenu.popoverPresentationController {
            if let selCell = tableView.cellForRow(at: indexPath) {
                popOver.sourceView = selCell
                popOver.sourceRect = selCell.bounds
            }
        }
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    //MARK: - Table View Cell Item manipulation
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            self.restaurants.remove(at: indexPath.row)
//            //tableView.reloadData()
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delectAction = UIContextualAction(style: .destructive, title: "Delect", handler: { (action, view, completeHandler) in
            self.restaurants.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completeHandler(true)
        })
        delectAction.backgroundColor = UIColor.red

        let markAction = UIContextualAction(style: .normal, title: self.restaurants[indexPath.row].isMarked ? "UnMark" : "Mark", handler: { (action, view, completeHandler) in
            let selCell = tableView.cellForRow(at: indexPath)
            self.restaurants[indexPath.row].isMarked = !self.restaurants[indexPath.row].isMarked
            selCell?.accessoryType = self.restaurants[indexPath.row].isMarked ? .checkmark : .none
            completeHandler(true)
        })
        markAction.backgroundColor = UIColor.blue
        
        let shareAction = UIContextualAction(style: .normal, title: "Share", handler: { (action, view, completeHandler) in
            var activityItems: [Any] = []
            let shareDesc = "Hi, this is a very good restaurant named \(self.restaurants[indexPath.row].name), look!"
            activityItems.append(shareDesc)
            if let shareImage = UIImage(named: self.restaurants[indexPath.row].thumbnailImageName) {
                activityItems.append(shareImage)
            }
            let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            if let popOverController = activityController.popoverPresentationController {
                let selCell = tableView.cellForRow(at: indexPath)!
                popOverController.sourceView = selCell
                popOverController.sourceRect = selCell.bounds
            }
            self.present(activityController, animated: true, completion: nil)
            completeHandler(true)
     
        })
        shareAction.backgroundColor = UIColor.orange
        
        let swipActionCfg = UISwipeActionsConfiguration(actions: [delectAction, markAction, shareAction])
        return swipActionCfg
    }


   
}
