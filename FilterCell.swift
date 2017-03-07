//
//  FilterCell.swift
//  HDAugmentedRealityDemo
//
//  Created by Andrey Apet on 3/7/17.
//  Copyright © 2017 Danijel Huis. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let label: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .black
        lb.font = UIFont.boldSystemFont(ofSize: 24)
        lb.textAlignment = .left
        return lb
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textColor = .black
        tf.font = UIFont.boldSystemFont(ofSize: 18)
        tf.textAlignment = .right
        tf.allowsEditingTextAttributes = false
        return tf
    }()
    
    func setupCell() {
        addSubview(label)
        addSubview(textField)
        
        backgroundColor = .white
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[lb(145)]-0-[tf]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["lb":label, "tf":textField]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lb]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["lb":label]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tf]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["tf":textField]))
    }
}
