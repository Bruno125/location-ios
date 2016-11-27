//
//  PlaceRepo.swift
//  LocationApp
//
//  Created by Bruno Aybar on 27/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

protocol PlaceRepo {
    func search(_ query:String, type :PlaceTypes) -> [Place]
    func getDetails(placeId :String) -> Place
    func getPhotos(referenceNumber :String) -> [String]
}
