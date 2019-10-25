//
//  NewsTableViewController.swift
//  SimpleRSSReader
//
//  Created by Simon Ng on 26/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    private var rssItems = [RSSItemModel]()
    private var rssItemExpandFlags = [Bool]()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 155.0
        tableView.rowHeight = UITableViewAutomaticDimension
        fetchRSS { (data, error) in
            if let _ = error {
                print("fetch error: \(error!.localizedDescription)")
                return
            }
            
            guard let _ = data else {
                return
            }
            
            let parser = RSSParse()
            parser.parse(data: data!) { [weak self] (results, error) in
                if let _ = error {
                    print("parsed error: \(error!.localizedDescription)")
                    return
                }
                
                self?.rssItems = results
                self?.rssItemExpandFlags = Array(repeating: false, count: results.count)
                print("parse reslut: \(results)")
                OperationQueue.main.addOperation { [weak self] in
                    self?.tableView.beginUpdates()
                    self?.tableView.reloadSections(IndexSet(integer: 0), with: .none)
                    self?.tableView.endUpdates()
                }
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return self.rssItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rssCell =  tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
        let rssItem = self.rssItems[indexPath.row]
        let expanded = self.rssItemExpandFlags[indexPath.row]
        rssCell.titleLabel.text = rssItem.title
        rssCell.dateLabel.text = rssItem.pubDate
        rssCell.descriptionLabel.text = rssItem.description
        rssCell.titleLabel.numberOfLines = 0
        rssCell.descriptionLabel.numberOfLines = expanded ? 0 : 4
        
        return rssCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.rssItemExpandFlags[indexPath.row] = !self.rssItemExpandFlags[indexPath.row]
        let rssCell = tableView.cellForRow(at: indexPath) as! NewsTableViewCell
        tableView.beginUpdates()
        rssCell.descriptionLabel.numberOfLines = self.rssItemExpandFlags[indexPath.row] ? 0 : 4
        tableView.endUpdates()
    }
    
    private func fetchRSS(complectionHandler: @escaping (Data?,Error?)->Void) {
        guard let url = URL(string: "https://developer.apple.com/news/rss/news.rss") else {
            complectionHandler(nil,nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            complectionHandler(data,error)
        }
        task.resume()
    }

}
