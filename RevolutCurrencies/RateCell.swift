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
    
    let currenciesLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let rateTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addUIElements()
    }
    
    func addUIElements() {
        addSubview(cellView)
        cellView.addSubview(currenciesLabel)
        cellView.addSubview(rateTextField)
        
        cellView.setAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        currenciesLabel.setAnchor(top: nil, left: cellView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0)
        currenciesLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        
        rateTextField.setAnchor(top: nil, left: currenciesLabel.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, height: 30)
        rateTextField.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
