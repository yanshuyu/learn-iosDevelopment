//
//  Loan.swift
//  jsonParsing
//
//  Created by sy on 2019/10/12.
//  Copyright © 2019 sy. All rights reserved.
//

import Foundation

struct Loan: Codable {
    var name: String = ""
    var country: String = ""
    var use: String = ""
    var amount: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case name
        case country = "location"
        case use
        case amount = "loan_amount"
    }
    
    enum LocationKeys: String, CodingKey {
        case country
    }
    
    init(name: String, country: String, use: String, amount: Int) {
        self.name = name
        self.country = country
        self.use = use
        self.amount = amount
    }
    
    init(from decoder: Decoder) throws {
        let loanContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try loanContainer.decode(String.self, forKey: .name)
        self.use = try loanContainer.decode(String.self, forKey: .use)
        self.amount = try loanContainer.decode(Int.self, forKey: .amount)
        
        let locationContainer = try loanContainer.nestedContainer(keyedBy: LocationKeys.self, forKey: .country)
        self.country = try locationContainer.decode(String.self, forKey: .country)
    }
}



struct LoanDataStore: Codable {
    var loans: [Loan] = []
    
}
