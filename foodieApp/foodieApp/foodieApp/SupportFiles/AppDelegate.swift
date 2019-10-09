//
//  AppDelegate.swift
//  foodieApp
//
//  Created by sy on 2019/4/12.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // MARK: - Application Data Source
//        let restaurantFactory = RestaurantFactory.getInstance()
//        let restaurants: [Restaurant] = [
//            Restaurant(name: "        ", location: "Hong Kong", category: "Coffe $ Tea Shop", thumbnailImageName: "barrafina", isMarked: false, description: "Inceptos imperdiet duis. Habitant Mattis consectetuer tempus conubia senectus leo lacinia facilisi erat diam nonummy metus cras lobortisaenean cras ridiculus a. Pede dapibus dictumst urna. Per purus viverra viverra. Vivamus mollis, curabitur volutpat. Integer fringilla, at neque, adipiscing varius mus nulla ornare pulvinar dolor interdum malesuada phasellus integer viverra urna pharetra hendrerit class dapibus nascetur natoque laoreet Cras a nisi nisl natoque cum felis euismod id fusce. Consectetuer felis mi malesuada enim potenti fermentum. Lobortis aliquam nisl. Volutpat. In.Diam porttitor sollicitudin netus nascetur consectetuer at. Cubilia quam. Nascetur dignissim. Habitasse, bibendum ultricies Imperdiet tincidunt rhoncus nunc Nibh egestas." ),
//            Restaurant(name: "bourkestreetbakery", location: "Hong Kong", category: "Cafe", thumbnailImageName: "bourkestreetbakery", isMarked: false, description: ""),
//                Restaurant(name: "cafedeadend", location: "Hong Kong", category: "Tea House", thumbnailImageName: "cafedeadend", isMarked: false, description: ""),
//                Restaurant(name: "cafeloisl", location: "Hong Kong", category: "Austrian / Causual Drink", thumbnailImageName: "cafeloisl", isMarked: false, description: ""),
//                Restaurant(name: "cafelore", location: "Hong Kong", category: "French", thumbnailImageName: "cafelore", isMarked: false, description: ""),
//                Restaurant(name: "caskpubkitchen", location: "Hong Kong", category: "Bakery", thumbnailImageName: "caskpubkitchen", isMarked: false, description: ""),
//                Restaurant(name: "confessional", location: "Hong Kong", category: "Bakery", thumbnailImageName: "confessional", isMarked: false, description: ""),
//                Restaurant(name: "donostia", location: "Sydney", category: "Chocolate", thumbnailImageName: "donostia", isMarked: false, description: ""),
//                Restaurant(name: "cafedeadend", location: "Sydney", category: "Cafe", thumbnailImageName: "cafedeadend", isMarked: false, description: ""),
//                Restaurant(name: "fiveleaves", location: "Sydney", category: "American / Sea Food", thumbnailImageName: "fiveleaves", isMarked: false, description: ""),
//                Restaurant(name: "forkeerestaurant", location: "New York", category: "American", thumbnailImageName: "forkeerestaurant", isMarked: false, description: ""),
//                Restaurant(name: "grahamavenuemeats", location: "New York", category: "American", thumbnailImageName: "grahamavenuemeats", isMarked: false, description: ""),
//                Restaurant(name: "haighschocolate", location: "New York", category: "Breakfast & Brunch", thumbnailImageName: "haighschocolate", isMarked: false, description: ""),
//                Restaurant(name: "homei", location: "New York", category: "Cafe & Tea", thumbnailImageName: "homei", isMarked: false, description: ""),
//                Restaurant(name: "palominoespresso", location: "New York", category: "Cafe & Tea", thumbnailImageName: "palominoespresso", isMarked: false, description: ""),
//                Restaurant(name: "petiteoyster", location: "New York", category: "American", thumbnailImageName: "petiteoyster", isMarked: false, description: ""),
//                Restaurant(name: "posatelier", location: "New York", category: "American", thumbnailImageName: "posatelier", isMarked: false, description: ""),
//                Restaurant(name: "royaloak", location: "London", category: "Spanish", thumbnailImageName: "royaloak", isMarked: false, description: ""),
//                Restaurant(name: "teakha", location: "London", category: "Spanish", thumbnailImageName: "teakha", isMarked: false, description: ""),
//                Restaurant(name: "traif", location: "unkoLondonnwed", category: "Spanish", thumbnailImageName: "traif", isMarked: false, description: ""),
//                Restaurant(name: "upstate", location: "London", category: "British", thumbnailImageName: "upstate", isMarked: false, description: ""),
//                Restaurant(name: "wafflewolf", location: "London", category: "Thai", thumbnailImageName: "wafflewolf", isMarked: false, description: ""),
//            ]
//        restaurantFactory.appendRestaurants(restaurants)
        
        // MARK: - UITableView NavigationBar Apparence Customizing (global)
//        let backIndicator = UIImage(named: "back")
//        UINavigationBar.appearance().backIndicatorImage = backIndicator
//        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backIndicator
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        RestaurantFactory.getInstance().reset()
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if let action = shortcutItem.type.split(separator: ".").last {
            switch action {
            case "new":
                if let tabBarVC = self.window?.rootViewController as? UITabBarController {
                    tabBarVC.selectedIndex = 0
                    if let navVC = tabBarVC.selectedViewController as? UINavigationController,
                    navVC.children.count <= 1 {
                        navVC.children[0].performSegue(withIdentifier: "newRestaurant", sender: nil)
                        completionHandler(true)
                        return
                    }
                }
                completionHandler(false)
                break

                
            case "about":
                if let tabBarVC = self.window?.rootViewController as? UITabBarController {
                    if let navVC = tabBarVC.selectedViewController as? UINavigationController,
                    navVC.children.count <= 1 {
                        tabBarVC.selectedIndex = 1
                        completionHandler(true)
                        return
                    }
                }
                completionHandler(false)
                break
            default:
                completionHandler(false)
            }
            
        }
    }
    
    
    // MARk - : CoreData Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "foodie")
        container.loadPersistentStores(completionHandler: { (description:NSPersistentStoreDescription, error: Error?) in
            if let error = error as NSError? {
               fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

