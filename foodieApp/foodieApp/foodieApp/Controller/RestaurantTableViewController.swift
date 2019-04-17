//
//  RestaurantTableViewController.swift
//  foodieApp
//
//  Created by sy on 2019/4/12.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.cellLayoutMarginsFollowReadableWidth = true
        
    // MARK: - NavigationController Customizing
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        if let rubikFont = UIFont(name: "Rubik-Medium", size: 40){
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: rubikFont,
                                                                                 NSAttributedString.Key.foregroundColor: UIColor(red: 231.0 / 255.0, green: 76.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)]
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnSwipe = true
        self.tableView.reloadData()
    }
    
    // MARK: - Statuts bar Customizing
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RestaurantFactory.getInstance().getRestaurants().count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as! RestaurantTableViewCell
        cell.initByData(RestaurantFactory.getInstance().getRestaurants()[indexPath.row])

        return cell
    }
 
    //MARK: - Table View Cell Item manipulation
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
//        let optionMenu = UIAlertController(title: nil, message: "What Do You Want To Do ?", preferredStyle: .actionSheet)
//        let callAction = UIAlertAction(title: "Call 123-000-\(indexPath.row)", style: .default, handler: { (action: UIAlertAction) -> Void in
//            let callMenu = UIAlertController(title: nil, message: "Call Feature Now Is No Available", preferredStyle: .alert)
//            let cancelCallAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            callMenu.addAction(cancelCallAction)
//            self.present(callMenu, animated: true, completion: nil)
//        })
//        let markAction = UIAlertAction(title: "Mark", style: .default, handler: { (action: UIAlertAction) -> Void in
//            let selCell = tableView.cellForRow(at: indexPath)
//            selCell?.accessoryType = .checkmark
//            tableView.deselectRow(at: indexPath, animated: false)
//            self.restaurants[indexPath.row].isMarked = true
//        })
//        let unmarkAction = UIAlertAction(title: "UnMark", style: .default, handler: { (action: UIAlertAction) -> Void in
//            let selCell = tableView.cellForRow(at: indexPath)
//            selCell?.accessoryType = .none
//            tableView.deselectRow(at: indexPath, animated: false)
//            self.restaurants[indexPath.row].isMarked = false
//        })
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        
//        let finalMarkAction = self.restaurants[indexPath.row].isMarked ? unmarkAction : markAction
//        
//        optionMenu.addAction(callAction)
//        optionMenu.addAction(finalMarkAction)
//        optionMenu.addAction(cancelAction)
//        
//        if let popOver = optionMenu.popoverPresentationController {
//            if let selCell = tableView.cellForRow(at: indexPath) {
//                popOver.sourceView = selCell
//                popOver.sourceRect = selCell.bounds
//            }
//        }
//        self.present(optionMenu, animated: true, completion: nil)
//    }
    
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            self.restaurants.remove(at: indexPath.row)
//            //tableView.reloadData()
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let restaurantData = RestaurantFactory.getInstance().getRestaurants()[indexPath.row]
        
        let markAction = UIContextualAction(style: .normal, title: nil, handler: { (action, view, completeHandler) in
        if let selCell = tableView.cellForRow(at: indexPath) as? RestaurantTableViewCell {
            restaurantData.isMarked = !restaurantData.isMarked
            self.updateMarkImageStateForCell(selCell, isVisible: restaurantData.isMarked)
        }
            completeHandler(true)
        })
        markAction.backgroundColor = restaurantData.isMarked ? UIColor.gray : UIColor.green
        markAction.image = UIImage(named: restaurantData.isMarked ? "undo" : "tick")
        
        let swipActionCfg = UISwipeActionsConfiguration(actions: [markAction])
        return swipActionCfg
    }

    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let restaurantData = RestaurantFactory.getInstance().getRestaurants()[indexPath.row]
        
        let delectAction = UIContextualAction(style: .destructive, title: nil, handler: { (action, view, completeHandler) in
            if let _ = RestaurantFactory.getInstance().removeRestaurantAtIndex(indexPath.row) {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            completeHandler(true)
        })
        delectAction.backgroundColor = UIColor.red
        delectAction.image = UIImage(named: "delete")
        
        let markAction = UIContextualAction(style: .normal, title: restaurantData.isMarked ? "UnMark" : "Mark", handler: { (action, view, completeHandler) in
            if let selCell = tableView.cellForRow(at: indexPath) as? RestaurantTableViewCell {
                restaurantData.isMarked = !restaurantData.isMarked
                self.updateMarkImageStateForCell(selCell, isVisible: restaurantData.isMarked)
            }
            completeHandler(true)
        })
        markAction.backgroundColor = UIColor.blue
        
        let shareAction = UIContextualAction(style: .normal, title: nil, handler: { (action, view, completeHandler) in
            var activityItems: [Any] = []
            let shareDesc = "Hi, this is a very good restaurant named \(restaurantData.name), look!"
            activityItems.append(shareDesc)
            if let shareImage = UIImage(named: restaurantData.thumbnailImageName) {
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
        shareAction.image = UIImage(named: "share")
        
        let swipActionCfg = UISwipeActionsConfiguration(actions: [delectAction, markAction, shareAction])
        return swipActionCfg
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainToDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let restaurantDetailView = segue.destination as! RestautantDetailViewController
                restaurantDetailView.restaurantData = RestaurantFactory.getInstance().getRestaurants()[indexPath.row]
            }
            
        }
    }
    
    
    // MARK: - Helper Function
    private func updateMarkImageStateForCell(_ cell: RestaurantTableViewCell, isVisible: Bool){
        cell.markImageView.isHidden = !isVisible
        cell.tintColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
    }

   
}

