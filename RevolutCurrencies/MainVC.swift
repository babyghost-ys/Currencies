//
//  ViewController.swift
//  RevolutCurrencies
//
//  Created by Peter Leung on 20/1/2019.
//  Copyright © 2019 Peter Leung. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    //Adding table view and the cell name
    let cellName = "cell"
    
    let ratesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //ApiHandler Test
    let apiHandler = ApiHandler()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Trying to add the table view to the main interface
        view.addSubview(ratesTableView)
        setupLayout()
        
        //ApiHandler Test
        apiHandler.requestData("https://revolut.duckdns.org/latest?base=GBP") { (returnedData) in
            
            if let ratesDictionary = returnedData as? [String : Any] {
                print(ratesDictionary["rates"])
            }
        }
    }

    //MARK: Adding the auto layout constraints for the table view
    func setupLayout() {
        let constraints = [ratesTableView.topAnchor.constraint(equalTo: view.topAnchor), ratesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor), ratesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),  ratesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        NSLayoutConstraint.activate(constraints)
    }
}

