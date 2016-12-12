//
//  PlaceRepository.swift
//  LocationApp
//
//  Created by Bruno Aybar on 03/12/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class PlaceRepository: PlaceRepo {

    static let sharedInstance = PlaceRepository()
    
    func search(_ query: String, type: PlaceTypes) -> [Place] {
        return PlaceFileSource.sharedInstance.search(query, type: type)
    }
    
    func getDetails(placeId: String) -> Place {
        return PlaceFileSource.sharedInstance.getDetails(placeId: placeId)
    }
    
    func getPhotos(referenceNumber: String) -> [String] {
        return PlaceFileSource.sharedInstance.getPhotos(referenceNumber: referenceNumber)
    }
    
}
