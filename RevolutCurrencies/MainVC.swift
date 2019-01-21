//
//  ViewController.swift
//  RevolutCurrencies
//
//  Created by Peter Leung on 20/1/2019.
//  Copyright © 2019 Peter Leung. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Adding table view and the cell name
    let cellName = "cell"
    
    let ratesTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    //ApiHandler Test
    let apiHandler = ApiHandler()
    
    //Holding the converted currencies and rates
    var currencies = [Currency]()
    
    //Create a timer to try to get data every second
    var liveTimer:Timer?
    
    //Setting default base currency and curreny amount
    var currentBaseCurrency = "GBP"
    var currentRate:Double = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Trying to add the table view to the main interface
        view.addSubview(ratesTableView)
        setupLayout()
        
        //Register the table view cell id first
        ratesTableView.register(RateCell.self, forCellReuseIdentifier: cellName)
        
        //Set the delegate and data source
        ratesTableView.delegate = self
        ratesTableView.dataSource = self
        
        startUpdateRates()
    }

    func startUpdateRates() {
        //Updating every second
        liveTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(loadData), userInfo: nil, repeats: true)
    }
    
    @objc func loadData() {
        //ApiHandler Test
        apiHandler.requestData("https://revolut.duckdns.org/latest?base=\(currentBaseCurrency)") { (returnedData) in
            
            if let ratesDictionary = returnedData as? [String : Any] {
                if let rates = ratesDictionary["rates"] as? [String : Any] {
                    
                    //Update UI and data at the main thread
                    DispatchQueue.main.async {
                        self.currencies.removeAll()
                        
                        for rate in rates {
                            //Grab the rate value from the dictionary first
                            let rateValue = rate.value as? Double ?? 0
                            
                            //Create the Currency object and multiple by the user's entered amount (currentRate)
                            let currency = Currency(rate.key, rate: rateValue * self.currentRate)
                            self.currencies.append(currency)
                        }
                        
                        //Add back the current base currency
                        let baseCurrency = Currency(self.currentBaseCurrency, rate: self.currentRate)
                        self.currencies.insert(baseCurrency, at: 0)
                        
                        self.ratesTableView.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK: Adding the auto layout constraints for the table view
    func setupLayout() {
        ratesTableView.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    //MARK: Main table view delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currencies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as? RateCell else {
            return RateCell()
        }
        
        if self.currencies.count > 0 {
            cell.configureCell(self.currencies[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        liveTimer?.invalidate()
        
        ratesTableView.beginUpdates()
        ratesTableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        ratesTableView.endUpdates()
        
        currentBaseCurrency = currencies[indexPath.row].currency ?? "EUR"
        
        startUpdateRates()
    }
}

