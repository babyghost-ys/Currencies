//
//  RateCell.swift
//  RevolutCurrencies
//
//  Created by Peter Leung on 21/1/2019.
//  Copyright © 2019 Peter Leung. All rights reserved.
//

import UIKit

class RateCell: UITableViewCell {

    let cellView: UIView = {
        let view = UIView()
        return view
    }()
    
    let currencyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let rateTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = UIKeyboardType.decimalPad
        textField.textAlignment = .right
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addUIElements()
    }
    
    func addUIElements() {
        addSubview(cellView)
        cellView.addSubview(currencyLabel)
        cellView.addSubview(rateTextField)
        
        cellView.setAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        currencyLabel.setAnchor(top: nil, left: cellView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0)
        currencyLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        
        rateTextField.setAnchor(top: nil, left: currencyLabel.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, height: 30)
        rateTextField.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
    }

    func configureCell(_ inputCurrency: Currency) {
        currencyLabel.text = "\(inputCurrency.currency ?? "")"
        
        //Rounding the currency rate
        let rate = String(format: "%.3f", inputCurrency.rate ?? 0)
        rateTextField.text = rate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
