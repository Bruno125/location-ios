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
}

class PlaceTypes{
    
    class Restaurant : PlaceType{
        let name = "Restaurant"
        let key = "restaurant"
    }
    
    class Hospital : PlaceType{
        let name = "Art gallery"
        let key = "art_gallery"
    }
    
    class Atm : PlaceType{
        let name = "ATM"
        let key = "atm"
    }
    
    class Parking : PlaceType{
        let name = "Parking"
        let key = "parking"
    }
    
    class Cafe : PlaceType{
        let name = "Cafe"
        let key = "cafe"
    }
    
    class University : PlaceType{
        let name = "University"
        let key = "university"
    }
    
    class TrainStation : PlaceType{
        let name = "Train station"
        let key = "train_station"
    }
}
