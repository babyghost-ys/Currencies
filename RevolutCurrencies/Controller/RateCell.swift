//
//  RateCell.swift
//  RevolutCurrencies
//
//  Created by Peter Leung on 21/1/2019.
//  Copyright © 2019 Peter Leung. All rights reserved.
//

import UIKit

class RateCell: UITableViewCell {
    
    let countryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        addSubview(countryImageView)
        addSubview(currencyLabel)
        addSubview(rateTextField)
        
        countryImageView.setAnchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        countryImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        currencyLabel.setAnchor(top: nil, left: countryImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0)
        currencyLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        rateTextField.setAnchor(top: nil, left: currencyLabel.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, height: 30)
        rateTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    func configureCell(_ inputCurrency: Currency) {
        let currency = inputCurrency.currency ?? ""
        countryImageView.image = UIImage(named: currency)
        currencyLabel.text = currency
        
        //Rounding the currency rate
        let rate = String(format: "%.3f", inputCurrency.rate ?? 0)
        rateTextField.text = rate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
