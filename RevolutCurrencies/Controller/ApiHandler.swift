//
//  ApiHandler.swift
//  RevolutCurrencies
//
//  Created by Peter Leung on 20/1/2019.
//  Copyright © 2019 Peter Leung. All rights reserved.
//

import Foundation
import Alamofire

class ApiHandler {
    
    func requestData(_ requestURL:String, completionHandler: @escaping(Any) -> Void) {
        
        let queue = DispatchQueue(label: "com.winandmac.RevolutCurrencies", qos: .background, attributes: .concurrent)
        
        Alamofire.request(requestURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: [:]).responseJSON(queue: queue) { (response) in
            
            guard let returnedData = response.result.value else { return }
            completionHandler(returnedData)
        }
    }
}
