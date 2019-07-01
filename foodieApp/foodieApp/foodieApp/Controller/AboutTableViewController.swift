//
//  AboutTableViewController.swift
//  foodieApp
//
//  Created by sy on 2019/5/30.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit
import SafariServices

class AboutTableViewController: UITableViewController {
    
    let sectionsData = [
        (title:NSLocalizedString("about-feedback-section-title", comment: "about scene table view feedback section title"), rows:[
            (image:"store", text:NSLocalizedString("rate-us-on-app-store", comment: "Rate us on App Store"), link:"https://www.apple.com/itunes/charts/paid-apps/"),
            (image:"chat", text:NSLocalizedString("tell-us-your-feedback", comment: "Tell us your feedback"), link:"https://www.appcoda.com/contact"),
            ]),
        (title:NSLocalizedString("about-followus-section-title", comment: "about scene table view follow us section title") , rows:[
                                    (image:"twitter", text:NSLocalizedString("follow-us-twitter", comment: ""), link:"https://twitter.com/appcodamobile"),
                                    (image:"facebook", text:NSLocalizedString("follow-us-facebook", comment: ""), link:"https://facebook.com/appcodamobile"),
                                    (image:"instagram", text:NSLocalizedString("follw-us-instagram", comment: ""), link:"https://www.instagram.com/appcodadotcom"),
            ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if let rubikFont = UIFont(name: "Rubik-Medium", size: 40){
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: rubikFont,
                                                                                 NSAttributedString.Key.foregroundColor: UIColor(red: 231.0 / 255.0, green: 76.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)]
        }
        //transparent navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        // back button
        let backIndicator = UIImage(named: "back");
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil);
        self.navigationController?.navigationBar.backIndicatorImage = backIndicator;
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backIndicator;
        // remove seperator of blank rows
        self.tableView.tableFooterView = UIView()
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionsData.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionsData[section].title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionsData[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell", for: indexPath)
        let cellData = self.sectionsData[indexPath.section].rows[indexPath.row]
        
        cell.imageView?.image = UIImage(named: cellData.image)
        cell.textLabel?.text = cellData.text
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AboutToWeb" {
            if let webViewContrller = segue.destination as? WKWebViewController,
                let url = sender as? URL {
                    webViewContrller.url = url
            }
        }
    }
    
    // MARK: - table view dalegate
 
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowData = self.sectionsData[indexPath.section].rows[indexPath.row]
        
        if indexPath.section == 0 {
            // open web with mobile safari
            if indexPath.row == 0 {
                UIApplication.shared.open(URL(string: rowData.link)!, options: [:], completionHandler: nil)
            } else if indexPath.row == 1 {
                let link = self.sectionsData[indexPath.section].rows[indexPath.row].link
                if let url = URL(string: link) {
                    performSegue(withIdentifier: "AboutToWeb", sender: url)
                }
            }
        } else if indexPath.section == 1 {
            guard let webUrl = URL(string: rowData.link) else {
                return
            }
            let safariController = SFSafariViewController(url: webUrl)
            present(safariController, animated: true, completion: nil)
            
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }

}
