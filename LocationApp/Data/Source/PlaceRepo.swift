//
//  PlaceRepo.swift
//  LocationApp
//
//  Created by Bruno Aybar on 27/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift

protocol PlaceRepo {
    func nearby(latitude :Double, longitude :Double, radius :Int, type :[PlaceType]) -> Observable<[Place]>
    func getDetails(placeId :String) -> Observable<Place>
    func getPhotos(referenceNumber :String) -> Observable<[String]>
}
