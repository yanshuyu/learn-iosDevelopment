//
//  AnimalTableViewController.swift
//  IndexedTableDemo
//
//  Created by Simon Ng on 3/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class AnimalTableViewController: UITableViewController {
    let animals = ["Bear",
                   "Black Swan",
                   "Buffalo",
                   "Camel",
                   "Cockatoo",
                   "Dog",
                   "Donkey",
                   "Emu",
                   "Giraffe",
                   "Greater Rhea",
                   "Hippopotamus",
                   "Horse",
                   "Koala",
                   "Lion",
                   "Llama",
                   "Manatus",
                   "Meerkat",
                   "Panda",
                   "Peacock",
                   "Pig",
                   "Platypus",
                   "Polar Bear",
                   "Rhinoceros",
                   "Seagull",
                   "Tasmania Devil",
                   "Whale",
                   "Whale Shark",
                   "Wombat"]
    
    var animalsDict: [String : [String]] = [:]
    var animalsKeys: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareData()
        print("animals dict: \(self.animalsDict)")
        print("animals keys: \(self.animalsKeys)")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor =  UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
            headerView.backgroundView?.backgroundColor = UIColor(red: 236.0/255.0, green: 240.0/255.0, blue: 241.0/255.0, alpha: 1.0)
            headerView.textLabel?.font = UIFont(name: "Avenir", size: 25.0)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return self.animalsKeys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        guard let animalSection = self.animalsDict[self.animalsKeys[section]] else {
            return 0
        }
        return animalSection.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.animalsKeys[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let animalSection = self.animalsDict[self.animalsKeys[indexPath.section]] {
            // Configure the cell...
            cell.textLabel?.text = animalSection[indexPath.row]
            // Convert the animal name to lower case and
            // then replace all occurences of a space with an underscore
            let imageFileName = animalSection[indexPath.row].lowercased().replacingOccurrences(of: " ", with: "_")
            cell.imageView?.image = UIImage(named: imageFileName)
        }
        
        return cell
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        //return self.animalsKeys
        return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L" , "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        guard let index = self.animalsKeys.firstIndex(of: title) else {
            return -1
        }
        return index
    }
    
    // MARK: - helper functions
    private func prepareData() {
        animals.forEach { (name: String) in
            let fstCharEndIndex = name.index(name.startIndex, offsetBy: 1)
            let key = String(name[..<fstCharEndIndex]).uppercased()
            if (self.animalsDict[key] != nil) {
                self.animalsDict[key]?.append(name)
            } else {
                self.animalsDict[key] = [name]
            }
        }
        
        self.animalsKeys = self.animalsDict.keys.sorted(by: {
            $0 < $1
        })
    }


}
