//
//  CategoryCollectionViewCell.swift
//  LocationApp
//
//  Created by Bruno Aybar on 15/12/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var maxWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        layer.cornerRadius = 4
        maxWidthConstraint.constant = UIScreen.main.bounds.width - 20
        setUI(selected: false)
    }
    
    
    
    func setUI(selected: Bool){
        if selected {
            mainLabel.textColor = .white
            backgroundColor = UIColor.enabledColor()
        }else{
            mainLabel.textColor = .darkGray
            backgroundColor = UIColor.disabledColor()
        }
    }
    
}
