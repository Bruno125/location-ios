//
//  LocationUtils.swift
//  LocationApp
//
//  Created by Bruno Aybar on 12/12/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift

class LocationUtils : NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationUtils()
    private let locationManager = CLLocationManager()
    
    private let locationSubject = PublishSubject<CLLocationCoordinate2D>()
    func getCurrentLocation() -> Observable<CLLocationCoordinate2D>{
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        //Check if service is enabled
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        return locationSubject.asObservable()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coordinates:CLLocationCoordinate2D = manager.location!.coordinate
        locationSubject.onNext(coordinates)
        locationManager.stopUpdatingLocation()
    }
    
    
    private let statusSubject = PublishSubject<LocationStatus>()
    func request() -> Observable<LocationStatus>{
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        return statusSubject.asObservable()
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        statusSubject.onNext(getStatus(status))
    }
    
    func getLocationStatus() -> Observable<LocationStatus>{
        if CLLocationManager.locationServicesEnabled() {
            return Observable.just(getStatus(CLLocationManager.authorizationStatus()))
        } else {
            return Observable.just(.notRequested)
        }
    }
    
    private func getStatus(_ status: CLAuthorizationStatus) -> LocationStatus {
        switch(status) {
        case .notDetermined:
            return .notRequested
        case .restricted, .denied:
            return .denied
        case .authorizedAlways, .authorizedWhenInUse:
            return .available
        }

    }
    
}

enum LocationStatus {
    case notRequested
    case available
    case denied
}
