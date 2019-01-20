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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //ApiHandler Test
    let apiHandler = ApiHandler()
    
    //Holding the converted currencies and rates
    var currencies = [String]()
    var rates = [Double]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Trying to add the table view to the main interface
        view.addSubview(ratesTableView)
        setupLayout()
        
        //Register the table view cell id first
        ratesTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellName)
        
        //Set the delegate and data source
        ratesTableView.delegate = self
        ratesTableView.dataSource = self
        
        //ApiHandler Test
        apiHandler.requestData("https://revolut.duckdns.org/latest?base=GBP") { (returnedData) in
            
            if let ratesDictionary = returnedData as? [String : Any] {
                if let rates = ratesDictionary["rates"] as? [String : Any] {
                    self.currencies = rates.map {$0.key}
                    self.rates = rates.map {$0.value} as? [Double] ?? []
                    self.ratesTableView.reloadData()
                }
            }
        }
    }

    //MARK: Adding the auto layout constraints for the table view
    func setupLayout() {
        let constraints = [ratesTableView.topAnchor.constraint(equalTo: view.topAnchor), ratesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor), ratesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),  ratesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        NSLayoutConstraint.activate(constraints)
    }
    
    //MARK: Main table view delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)
        cell.textLabel?.text = "\(self.currencies[indexPath.row]) \(self.rates[indexPath.row])"
        return cell
    }
}

