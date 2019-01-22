//
//  DataHandler.swift
//  RevolutCurrencies
//
//  Created by Peter Leung on 22/1/2019.
//  Copyright © 2019 Peter Leung. All rights reserved.
//

import Foundation

class DataHandler {
    
    let apiHandler = ApiHandler()
    
    func getData(_ currentBaseCurrency: String, completionHandler: @escaping([String : Any]) -> Void) {
        
        apiHandler.requestData("https://revolut.duckdns.org/latest?base=\(currentBaseCurrency)") { (returnedData) in
            
            //Parse the data as dictionary first
            if let ratesDictionary = returnedData as? [String : Any] {
                if let rates = ratesDictionary["rates"] as? [String : Any] {
                    completionHandler(rates)
                }
            }
        }
        
    }
}
