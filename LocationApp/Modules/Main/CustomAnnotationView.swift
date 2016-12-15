//
//  CustomAnnotationView.swift
//  LocationApp
//
//  Created by Bruno Aybar on 14/12/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import MapKit

class CurrentLocationAnnotation: MKPointAnnotation {

    let image = UIImage(named: "pin_current_location")

    override init() {
        super.init()
        title = "You're here"
    }
}

class PlaceAnnotation: MKPointAnnotation {
    
    var place: Place
    let image = UIImage(named: "pin_place_normal")
    let imageSelected = UIImage(named: "pin_place_selected")
    
    init(with place: Place){
        self.place = place
        super.init()
        let centerCoordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude:place.longitude)
        coordinate = centerCoordinate
    }
}
