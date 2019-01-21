//
//  Currencies.swift
//  RevolutCurrencies
//
//  Created by Peter Leung on 21/1/2019.
//  Copyright © 2019 Peter Leung. All rights reserved.
//

import Foundation

class Currency {
    private(set) var currency: String?
    private(set) var rate: Double?
    
    init(_ currency: String, rate: Double) {
        self.currency = currency
        self.rate = rate
    }
}
