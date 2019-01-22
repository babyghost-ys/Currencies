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
    let apiHandler = ApiHandler()
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
    
    //Testing whether the Currency object would be nil or not
    func testRefreshCurencyObject() {
        mainVC.dataHandler.getData(mainVC.currentBaseCurrency, completionHandler: { (rates) in
            self.mainVC.refreshCurrencyData(rates: rates)
            
            if self.mainVC.currencies.count >= 0 {
                self.promise.fulfill()
            } else {
                XCTFail("Currency object unable to get data")
            }
        })
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    //Making sure the total number of Currency object is equals to the total number of received data (rates.count).
    func testReturnedDataCount() {
        mainVC.dataHandler.getData(mainVC.currentBaseCurrency, completionHandler: { (rates) in
            self.mainVC.refreshCurrencyData(rates: rates)
            
            if self.mainVC.currencies.count == rates.count {
                self.promise.fulfill()
            } else {
                XCTFail("Total count of [Currency] class object is not correct")
            }
        })
        waitForExpectations(timeout: 3, handler: nil)
    }
}
