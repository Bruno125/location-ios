//
//  PlaceServiceRepo.swift
//  LocationApp
//
//  Created by Bruno Aybar on 27/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class PlaceServiceRepo: PlaceRepo {
    func search(_ query: String, type: PlaceTypes) -> [Place] {
        return []
    }
    
    func getDetails(placeId: String) -> Place {
        return Place(id: "",name: "", latitude: 0, longitude: 0, description: "", distance: 0, photoReferences: [], photoUrls: [])
    }
    
    func getPhotos(referenceNumber: String) -> [String] {
        return []
    }
    
}
