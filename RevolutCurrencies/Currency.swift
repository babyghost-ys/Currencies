//
//  Currencies.swift
//  RevolutCurrencies
//
//  Created by Peter Leung on 21/1/2019.
//  Copyright © 2019 Peter Leung. All rights reserved.
//

import Foundation

class Currency {
    var country: String?
    var rate: Double?
    
    init(country: String, rate: Double) {
        self.country = country
        self.rate = rate
    }
}
