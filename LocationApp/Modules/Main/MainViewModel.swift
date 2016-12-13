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
    
    private let currentLocationSubject = PublishSubject<CLLocation>()
    func getCurrentLocationStream() -> Observable<CLLocation>{
        return currentLocationSubject.asObserver()
    }
    func requestedCurrentLocation(){
        //TODO: get user location and notify view
    }
    
    
    // MARK: General
    
    func start(){
        let location = LocationUtils.getCurrentLocation().coordinate
        let request = mSource.nearby(latitude: location.latitude,
                       longitude: location.longitude,
                       radius: AppUtils.getRadius(), type: .none)
      
        
        
        request.flatMap { place in
            return Observable.from(place)
        }.subscribe(onNext:{ place in
            self.placesSubject.onNext(place)
        }).addDisposableTo(mDisposeBag)
        
        
    }
}
