//
//  PlaceRepository.swift
//  LocationApp
//
//  Created by Bruno Aybar on 03/12/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift

class PlaceRepository: PlaceRepo {

    static let sharedInstance = PlaceRepository()
    
    
    func nearby(latitude: Double, longitude: Double, radius :Int, type: [PlaceType]) -> Observable<[Place]>{
        return PlaceServiceRepo.sharedInstance.nearby(latitude: latitude, longitude: longitude, radius: radius, type: type)
    }
    
    func getDetails(placeId: String) -> Observable<Place> {
        return PlaceServiceRepo.sharedInstance.getDetails(placeId: placeId)
    }
    
    func getPhotos(referenceNumber: String) -> Observable<[String]> {
        return PlaceServiceRepo.sharedInstance.getPhotos(referenceNumber: referenceNumber)
    }
    
}
