//
//  RestautantDetailViewController.swift
//  foodieApp
//
//  Created by sy on 2019/4/14.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class RestautantDetailViewController: UIViewController {
    var restaurantData: Restaurant? = nil
    
    @IBOutlet var restaurantDetailHeaderView: RestautantDetailHeaderView!
    @IBOutlet var restaurantDetailTableView: UITableView!
    
    //MARK: - NavigationBar Customizing
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.tintColor = UIColor.white
      
        self.restaurantDetailTableView.delegate = self
        self.restaurantDetailTableView.dataSource = self
        self.restaurantDetailTableView.contentInsetAdjustmentBehavior = .never
        self.restaurantDetailHeaderView.typeLable.layer.cornerRadius = 5
        self.restaurantDetailHeaderView.typeLable.layer.masksToBounds = true
        
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil )
        self.navigationItem.backBarButtonItem = backButtonItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let data = restaurantData {
            self.restaurantDetailHeaderView.initByData(data)
        }
        
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    
    @IBAction func onMarkButtonClick(_ sender: UIButton) {
        if let data = self.restaurantData {
            data.isMarked = !data.isMarked
            self.restaurantDetailHeaderView.markButton.tintColor = data.isMarked ? #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1) : #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        }
        
    }
    
    
    // MARK: - Statuts bar Customizing
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: - Controller View Transaction
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailToMap" {
            if let restaurantDetailMapView = segue.destination as? RestaurantDetailMapViewController {
                restaurantDetailMapView.restaurantData = self.restaurantData
            }
            self.navigationItem.title = ""
        }
    }
    
}


//MARK - : UITableView Protocols

extension RestautantDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = self.restaurantDetailTableView.dequeueReusableCell(withIdentifier: "RestaurantDetailAPCell", for: indexPath) as! RestaurantDetailViewAPCell
            cell.iconImageView.image = UIImage(named: "phone")
            cell.shortDescLable.text = "123-000-\(indexPath.row)"
            return cell
        case 1:
            let cell = self.restaurantDetailTableView.dequeueReusableCell(withIdentifier: "RestaurantDetailAPCell", for: indexPath) as! RestaurantDetailViewAPCell
            cell.iconImageView.image = UIImage(named: "phone")
            cell.shortDescLable.text = self.restaurantData?.location
            return cell
        case 2:
            let cell = self.restaurantDetailTableView.dequeueReusableCell(withIdentifier: "RestaurantDetailDescCell", for: indexPath) as! RestautantDetailViewDescCell
            cell.longDescLable.text = self.restaurantData?.detailDesc == "" ? self.restaurantData?.description : self.restaurantData?.detailDesc
            
            return cell
        case 3:
            let cell = self.restaurantDetailTableView.dequeueReusableCell(withIdentifier: "MapHeaderCell", for: indexPath)
            return cell
            
        case 4:
            let cell = self.restaurantDetailTableView.dequeueReusableCell(withIdentifier: "ThumnailMapCell", for: indexPath) as! RestaurantDetailThumbnailMapCell
            cell.initByData(self.restaurantData)
            return cell
            
        default:
            fatalError("Restaurant Detail TableView should Never Have More Than 3 Rows!")
        }
    }
    
    
}
