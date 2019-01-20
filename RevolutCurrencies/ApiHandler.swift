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
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        manager.request(requestURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: [:]).responseJSON { (response) in
            
            guard let returnedData = response.result.value else { return }
            completionHandler(returnedData)
        }
    }
}
