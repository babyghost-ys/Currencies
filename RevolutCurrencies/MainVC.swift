//
//  ViewController.swift
//  RevolutCurrencies
//
//  Created by Peter Leung on 20/1/2019.
//  Copyright © 2019 Peter Leung. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
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
    
    //Add a check for the keyboard visible or not
    var keyboardVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.hideKeyboardWhenTapped()
        
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
    
    //MARK: Start to monitor keyboard when view appears
    override func viewWillAppear(_ animated: Bool) {
        startToMonitorKeyboard()
    }
    
    //MARK: Remove the notification center when the view starts to disappear
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Function to request data every 1 second
    func startUpdateRates() {
        liveTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(loadData), userInfo: nil, repeats: true)
    }
    
    //MARK: Main function to load data from the internet
    @objc func loadData() {
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
                        
                        //Add back the current base currency on top of the Currency object
                        let baseCurrency = Currency(self.currentBaseCurrency, rate: self.currentRate)
                        self.currencies.insert(baseCurrency, at: 0)
                        
                        if self.keyboardVisible == false {
                            //If keyboard is not shown (condition == false), just reload the whole table.
                            self.ratesTableView.reloadData()
                        } else {
                            //If keyboard is shown (condition == true), that means the user is entering value. So, we need to update each row.
                            self.ratesTableView.beginUpdates()
                            var changeIndexPath = [IndexPath]()
                            for x in 1..<self.currencies.count {
                                let currentIndexPath = IndexPath(row: x, section: 0)
                                changeIndexPath.append(currentIndexPath)
                            }
                            self.ratesTableView.reloadRows(at: changeIndexPath, with: .automatic)
                            self.ratesTableView.endUpdates()
                        }
                        
                    }
                }
            }
        }
        
    }
    
    //MARK: Notification centres to monitor the keyboard
    func startToMonitorKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillAppear() {
        liveTimer?.invalidate()
        keyboardVisible = true
    }
    
    @objc func keyboardWillDisappear() {
    }
    
    @objc func keyboardDidDisappear() {
        keyboardVisible = false
        startUpdateRates()
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
            cell.rateTextField.delegate = self
            cell.rateTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                         for: .editingChanged)
        }
        
        return cell
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if let currentText = textField.text, !currentText.isEmpty {
            guard let currentValue = Double(currentText) else { return }
            currentRate = currentValue
        } else {
            textField.placeholder = "0"
            currentRate = 0
        }
        
        loadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        liveTimer?.invalidate()
        
        ratesTableView.beginUpdates()
        ratesTableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        ratesTableView.endUpdates()
        
        //Grab the selected currency to prepare to fetch updated data
        let currentCurency = currencies[indexPath.row]
        currentBaseCurrency = currentCurency.currency ?? "EUR"
        currentRate = currentCurency.rate ?? 0.0
        
        //Remove the item in the currencies
        let removeItem = currencies.remove(at: indexPath.row)
        currencies.insert(removeItem, at: 0)
        
        //Scroll to top of the table view
        ratesTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        ratesTableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
        
        startUpdateRates()
    }
}

