//
//  RevolutCurrenciesTests.swift
//  RevolutCurrenciesTests
//
//  Created by Peter Leung on 20/1/2019.
//  Copyright © 2019 Peter Leung. All rights reserved.
//

import XCTest
@testable import RevolutCurrencies

class RevolutCurrenciesTests: XCTestCase {
    
    var mainVC: MainVC!

    override func setUp() {
        mainVC = MainVC()
        mainVC.loadViewIfNeeded()
    }

    override func tearDown() {
        mainVC = nil
        super.tearDown()
    }

    func testExample() {
        
    }

    func testPerformance() {
        self.measure {
            mainVC.apiHandler.requestData("https://revolut.duckdns.org/latest?base=\(mainVC.currentBaseCurrency)", completionHandler: { (any) in
            })
        }
    }

}
