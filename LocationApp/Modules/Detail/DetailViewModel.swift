//
//  DetailViewModel.swift
//  LocationApp
//
//  Created by Bruno Aybar on 14/12/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift
import CoreLocation

class DetailViewModel {

    
    private let mSource :PlaceRepo
    private let mDisposeBag = DisposeBag()
    private let mLocation : CLLocationCoordinate2D?
    
    init(source :PlaceRepo, location:CLLocationCoordinate2D? = nil){
        mSource = source
        mLocation = location
    }
    
    func getDetailsOnce(place: Place) -> Observable<Place>{
        return Observable.create { observer in
            self.mSource.getDetails(placeId: place.id).subscribe(onNext:{ place in
                if self.mLocation != nil {
                    let origin = (latitude: Double(self.mLocation!.latitude),
                                      longitude: Double(self.mLocation!.longitude))
                    let destination = (latitude:place.latitude,longitude:place.longitude)
                    self.mSource.getDistances(from: [origin],to: [destination])
                        .subscribe(onNext: { distances in
                            var distance = ""
                            if !distances.isEmpty {
                                distance = distances[0].distance
                            }
                            var temp = place
                            temp.distance = distance
                            observer.onNext(temp)
                        }, onError: { error in
                            observer.onError(error)
                        }, onCompleted: nil, onDisposed: nil).addDisposableTo(self.mDisposeBag)
                }else{
                    observer.onNext(place)
                }
                
            })
        }
    }
    
}
