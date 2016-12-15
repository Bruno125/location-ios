//
//  MainViewModel.swift
//  LocationApp
//
//  Created by Bruno Aybar on 12/12/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift
import CoreLocation

class MainViewModel {
    
    private let mSource :PlaceRepo
    private let mDisposeBag = DisposeBag()
    
    init(source :PlaceRepo){
        mSource = source
    }
    
    private let placesSubject = PublishSubject<Place>()
    func getPlacesStream() -> Observable<Place>{
        return placesSubject.asObserver()
    }
    
    // MARK: Location
    
    private let currentLocationSubject = PublishSubject<CLLocationCoordinate2D>()
    func getCurrentLocationStream() -> Observable<CLLocationCoordinate2D>{
        return currentLocationSubject.asObserver()
    }
    
    // MARK: General
    
    func requestPlaces(for location: CLLocationCoordinate2D){
        //Request places that are near our current location
        let request = self.mSource.nearby(latitude: location.latitude,
                                          longitude: location.longitude,
                                          radius: AppUtils.getRadius(), type: .none)
        request.flatMap { place in
            return Observable.from(place)
        }.subscribe(onNext:{ place in
            self.placesSubject.onNext(place)
        }).addDisposableTo(self.mDisposeBag)
    }
    
    func requestedCurrentLocation(){
        LocationUtils.sharedInstance.getCurrentLocation()
            .subscribe(onNext:{ location in
                //Notify location
                self.currentLocationSubject.onNext(location)
            }).addDisposableTo(mDisposeBag)
    }
    
    func userPicked(location: CLLocationCoordinate2D){
        currentLocationSubject.onNext(location)
    }
    
}
