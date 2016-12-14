//
//  PlaceTableViewCell.swift
//  LocationApp
//
//  Created by Bruno Aybar on 13/12/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var vicinityLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPlace(_ place: Place){
        self.nameLabel.text = place.name
        self.vicinityLabel.text = place.vicinity
        self.iconImageView.downloadedFrom(link: place.icon)
    }

}
