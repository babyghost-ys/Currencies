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
    var currencies = [String]()
    var rates = [Double]()
    
    //Create a timer to try to get data every second
    var liveTimer:Timer?

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
        
        //Updating every second
        liveTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(loadData), userInfo: nil, repeats: true)
    }

    @objc func loadData() {
        //ApiHandler Test
        apiHandler.requestData("https://revolut.duckdns.org/latest?base=GBP") { (returnedData) in
            
            if let ratesDictionary = returnedData as? [String : Any] {
                if let rates = ratesDictionary["rates"] as? [String : Any] {
                    self.currencies = rates.map {$0.key}
                    self.rates = rates.map {$0.value} as? [Double] ?? []
                    
                    //Update UI at the main thread
                    DispatchQueue.main.async {
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
        
        cell.rateLabel.text = "\(self.currencies[indexPath.row]) \(self.rates[indexPath.row])"
        return cell
    }
}

