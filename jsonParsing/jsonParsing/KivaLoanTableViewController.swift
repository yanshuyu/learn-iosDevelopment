//
//  KivaLoanTableViewController.swift
//  KivaLoan
//
//  Created by Simon Ng on 4/10/2016.
//  Updated by Simon Ng on 6/12/2017.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class KivaLoanTableViewController: UITableViewController {
    private var kivaLoanURL = URL(string: "https://api.kivaws.org/v1/loans/newest.json")
    private var loans = [Loan]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 92.0
        tableView.rowHeight = UITableView.automaticDimension
        
        fetchLoans { (result, error) in
            if let e = error {
                print("fetch error:\(e)")
                return
            }
            print("fetch reslut: \(result)")
            OperationQueue.main.addOperation {
                self.loans = result
                self.tableView.reloadData()
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
        return self.loans.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! KivaLoanTableViewCell

        // Configure the cell...
        let loan = self.loans[indexPath.row]
        cell.nameLabel.text = loan.name
        cell.useLabel.text = loan.use
        cell.countryLabel.text = loan.country
        cell.amountLabel.text = "\(loan.amount)"
        
        return cell
    }
    
    // MARK: - json data request
    private func fetchLoans(complectionHandler: @escaping ([Loan], Error?)->Void ) {
        guard let loanURL = self.kivaLoanURL else {
            complectionHandler([Loan](),nil)
            return
        }
        
        let kiavlLoanRequest = URLRequest(url: loanURL)
        let kiavlLoanRequestTask = URLSession.shared.dataTask(with: kiavlLoanRequest) {[weak self] (data, response, error) in
            if let e = error {
                complectionHandler([Loan](), e)
                return
            }
            
            guard let _ = data else {
                complectionHandler([Loan](), nil)
                return
            }
            
            if let strongSelf = self {
                let parsedResult = strongSelf.parseLoanData(data!)
                complectionHandler(parsedResult.0, parsedResult.1)
            }
        }
        kiavlLoanRequestTask.resume()
    }
    
    private func parseLoanData(_ data: Data) -> ([Loan],Error?) {
        var reslut = [Loan]()
        var e: Error? = nil
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:AnyObject]
            let loans = jsonData["loans"] as! [AnyObject]
            
            loans.forEach { (loanRecord) in
                let name = loanRecord["name"] as! String
                let use = loanRecord["use"] as! String
                let amout = loanRecord["loan_amount"] as! Int
                let location = loanRecord["location"] as! [String: AnyObject]
                let country = location["country"] as! String
                reslut.append(Loan(name: name, country: country, use: use, amount: amout))
            }
            
        } catch  {
           e = error
        }
        
        return (reslut, e)
    }


}
