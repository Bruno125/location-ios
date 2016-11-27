//
//  Place.swift
//  LocationApp
//
//  Created by Bruno Aybar on 27/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

struct Place {
    let id :String
    let name :String
    let latitude :Double
    let longitude :Double
    let description :String
    var distance :Double
    
    var photoReferences :[String]
    var photoUrls : [String]
    
}
