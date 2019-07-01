//
//  RestaurantTableViewController.swift
//  foodieApp
//
//  Created by sy on 2019/4/12.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit
import CoreData

class RestaurantTableViewController: UITableViewController {
    @IBOutlet weak var emptyView: UIView!
    
    lazy var restaurantDataFetchResultController: NSFetchedResultsController? = { () -> NSFetchedResultsController<RestaurantModel>? in
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can't access delegate of Foodie!")
        }
        let sortByNameDescpritor = NSSortDescriptor(key: "name", ascending: true)
        let fetchRequest: NSFetchRequest<RestaurantModel> = RestaurantModel.fetchRequest()
        fetchRequest.sortDescriptors = [sortByNameDescpritor]
        let fetchReslutController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                            managedObjectContext: appDelegate.persistentContainer.viewContext,
                                                            sectionNameKeyPath: nil,
                                                            cacheName: nil)
        fetchReslutController.delegate = self
        return fetchReslutController
    }()
    lazy var allRestaurant = [RestaurantModel]()
    lazy var searchRestaurant = [RestaurantModel]()
    
    var searchController: UISearchController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.cellLayoutMarginsFollowReadableWidth = true
        
        // MARK: - NavigationController Customizing
        //custom back button indicator and title
        let backIndicator = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorImage = backIndicator
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backIndicator
        
        let backButtomItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButtomItem
        
        //transparent navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        
        self.tableView.backgroundView = self.emptyView
        self.tableView.backgroundView?.isHidden = true
        
        //add search bar
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController?.searchResultsUpdater = self
        self.searchController?.dimsBackgroundDuringPresentation = false
        self.searchController?.searchBar.placeholder = NSLocalizedString("search-bar-place-holder", comment: "");
        self.navigationItem.searchController = self.searchController
        //self.tableView.tableHeaderView = self.searchController?.searchBar
        
        //load restaurant data
        loadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnSwipe = true
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        if let rubikFont = UIFont(name: "Rubik-Medium", size: 40){
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: rubikFont,
                                                                                 NSAttributedString.Key.foregroundColor: UIColor(red: 231.0 / 255.0, green: 76.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)]
        }
        
        //self.loadData()
        if self.allRestaurant.count > 0 {
            self.tableView.backgroundView?.isHidden = true
            self.tableView.separatorStyle = .singleLine
        }else{
            self.tableView.backgroundView?.isHidden = false
            self.tableView.separatorStyle = .none
        }
        self.tableView.reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if !UserDefaults.standard.bool(forKey: "hasCompletedWalkthrough") {
            let walkthroughSceneStoryboard = UIStoryboard(name: "WalkThroughScreen", bundle: nil)
            if let walkthroughViewController = walkthroughSceneStoryboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {
                present(walkthroughViewController, animated: false, completion: nil)
            }
        }

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
        //return RestaurantFactory.getInstance().getRestaurants().count
        return (self.searchController?.isActive  ?? false) ? searchRestaurant.count : allRestaurant.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as! RestaurantTableViewCell
        //cell.initByData(RestaurantFactory.getInstance().getRestaurants()[indexPath.row])
        let cellData = (self.searchController?.isActive ?? false) ? searchRestaurant[indexPath.row] : allRestaurant[indexPath.row]
        cell.initByData(cellData)
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
        //let restaurantData = RestaurantFactory.getInstance().getRestaurants()[indexPath.row]
        let restaurantData = self.allRestaurant[indexPath.row]
        let delectAction = UIContextualAction(style: .destructive, title: nil, handler: { (action, view, completeHandler) in
            var success = false
            //            if let _ = RestaurantFactory.getInstance().removeRestaurantAtIndex(indexPath.row) {
            //                tableView.deleteRows(at: [indexPath], with: .fade)
            //            }
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let managedObjectContext = appDelegate.persistentContainer.viewContext
                if let deletedRestaurant = self.restaurantDataFetchResultController?.object(at: indexPath) {
                    managedObjectContext.delete(deletedRestaurant)
                    appDelegate.saveContext()
                    success = true
                }
            }
            completeHandler(success)
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
            let shareDesc = "Hi, this is a very good restaurant named \(restaurantData.name!), look!"
            activityItems.append(shareDesc)
            if let imageData = restaurantData.thumbnailImage, let shareImage = UIImage(data: imageData) {
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
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        var canEdit = true
        if self.searchController?.isActive ?? false {
            canEdit = false
        }
        
        return canEdit
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainToDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let restaurantDetailView = segue.destination as! RestautantDetailViewController
                //restaurantDetailView.restaurantData = RestaurantFactory.getInstance().getRestaurants()[indexPath.row]
                let seleteRestaurant = (self.searchController?.isActive ?? false) ? searchRestaurant[indexPath.row] : allRestaurant[indexPath.row]
                restaurantDetailView.restaurantData = seleteRestaurant
            }
        }
    }
    
    
    
    // MARK: - Restaurant Core Data
    func loadData() -> Void {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            fatalError("Can't find AppDelegate of Foodie")
//        }

//        let fetchRequst: NSFetchRequest<RestaurantModel> = RestaurantModel.fetchRequest()
//        do {
//            try allRestaurant = appDelegate.persistentContainer.viewContext.fetch(fetchRequst)
//        }catch {
//            fatalError("Fetch core data error: \(error)")
//        }

        do {
            try self.restaurantDataFetchResultController?.performFetch()
        } catch {
            print("Fetch Data Error: \(error.localizedDescription)")
        }
        
        if let fetchResult = self.restaurantDataFetchResultController?.fetchedObjects {
            self.allRestaurant = fetchResult
        }
        print("Fetch all restaurant data from core data: \(self.allRestaurant)")
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue){
        if segue.identifier == "unwindFromNewToMain" {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Helper Function
    private func updateMarkImageStateForCell(_ cell: RestaurantTableViewCell, isVisible: Bool){
        cell.markImageView.isHidden = !isVisible
        cell.tintColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
    }
    
    
    private func filterRestauran(byName searchText: String) -> [RestaurantModel] {
        var filterResult: [RestaurantModel] = []
        filterResult = self.allRestaurant.filter { (restaurant) -> Bool in
            if let fullName = restaurant.name {
                if fullName.localizedCaseInsensitiveContains(searchText) {
                    return true
                }
            }
            
            return false
        }
        return filterResult
    }
    
   
}



// MARK: - Core Date FetchResultController Delegate
extension RestaurantTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       self.tableView.beginUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let insertIndexPath = newIndexPath {
                self.tableView.insertRows(at: [insertIndexPath], with: .automatic)
            }
            
        case .delete:
            if let deleteIndexPath = indexPath {
                self.tableView.deleteRows(at: [deleteIndexPath], with: .automatic)
            }
            
        case .update:
            if let updateIndexPath = indexPath {
                self.tableView.reloadRows(at: [updateIndexPath], with: .automatic)
            }
            
        default:
            self.tableView.reloadData()
        }
        
        
        if let latestRestaurants = controller.fetchedObjects {
            self.allRestaurant = latestRestaurants as! [RestaurantModel]
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        self.tableView.endUpdates()
    }

}


// MARK: - UISearchCotroller search reslut updater
extension RestaurantTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let userTypedText = searchController.searchBar.text {
            self.searchRestaurant = filterRestauran(byName: userTypedText)
            self.tableView.reloadData()
        }
    }
    
}

