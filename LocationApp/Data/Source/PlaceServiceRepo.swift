//
//  PlaceServiceRepo.swift
//  LocationApp
//
//  Created by Bruno Aybar on 27/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift

class PlaceServiceRepo: PlaceRepo {
    
    static let sharedInstance = PlaceServiceRepo()
    private init(){}
    
    func nearby(latitude: Double, longitude: Double, radius :Int, type: PlaceTypes) -> Observable<[Place]>{
        return Observable.just([])
    }
    
    func getDetails(placeId: String) -> Observable<Place> {
        return Observable.just(Place(id: "", name: "", latitude: 0, longitude: 0, address: "", phone: "", internationalPhone: "", rating: 0, distance: 0, photoReferences: [], photoUrls: []))
    }
    
    func getPhotos(referenceNumber: String) -> Observable<[String]> {
        return Observable.just([])
    }
    
}
