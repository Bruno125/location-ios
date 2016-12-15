//
//  PlaceTypes.swift
//  LocationApp
//
//  Created by Bruno Aybar on 27/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

protocol PlaceType{
    var name: String {get}
    var key: String {get}
    var selected: Bool {get set}
}

class PlaceTypes{
    
    class Restaurant : PlaceType{
        let name = "Restaurant"
        let key = "restaurant"
        var selected = false
    }
    
    class Hospital : PlaceType{
        let name = "Art gallery"
        let key = "art_gallery"
        var selected = false
    }
    
    class Atm : PlaceType{
        let name = "ATM"
        let key = "atm"
        var selected = false
    }
    
    class Parking : PlaceType{
        let name = "Parking"
        let key = "parking"
        var selected = false
    }
    
    class Cafe : PlaceType{
        let name = "Cafe"
        let key = "cafe"
        var selected = false
    }
    
    class University : PlaceType{
        let name = "University"
        let key = "university"
        var selected = false
    }
    
    class TrainStation : PlaceType{
        let name = "Train station"
        let key = "train_station"
        var selected = false
    }
}
