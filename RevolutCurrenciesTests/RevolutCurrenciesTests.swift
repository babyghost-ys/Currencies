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
    var promise: XCTestExpectation!
    
    override func setUp() {
        mainVC = MainVC()
        mainVC.loadViewIfNeeded()
        promise = expectation(description: "Test Passed!")
    }
    
    override func tearDown() {
        mainVC = nil
        super.tearDown()
    }
    
    //Testing async progress
    func testDownloadData() {
        mainVC.dataHandler.getData(mainVC.currentBaseCurrency, completionHandler: { (rates) in
            if rates.count > 0 {
                self.promise.fulfill()
            } else {
                XCTFail("Returned data is nil")
            }
        })
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testPerformance() {
        self.measure {
            mainVC.dataHandler.getData(mainVC.currentBaseCurrency, completionHandler: { (rates) in
                
            })
        }
    }
    
}
