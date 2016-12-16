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
    
    private var locationSubject = PublishSubject<CLLocationCoordinate2D>()
    func getCurrentLocation() -> Observable<CLLocationCoordinate2D>{
        //Init location subject
        locationSubject = PublishSubject<CLLocationCoordinate2D>()
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
        locationSubject.onCompleted()
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
    
    static func openDirections(to destiny:CLLocationCoordinate2D, controller : UIViewController?) {
        let options : [ (name: String, url: String) ] = [
            ("Waze","waze://?ll=\(destiny.latitude),\(destiny.longitude)&navigate=yes"),
            ("Google Maps","comgooglemaps://maps.google.com/maps?q=\(destiny.latitude),\(destiny.longitude)"),
            ("Maps","maps://maps.google.com/maps?q=\(destiny.latitude),\(destiny.longitude)")
        ]
        
        var availableOptions : [(name: String, url: String)] = []
        for option in options {
            let canOpen = UIApplication.shared.canOpenURL(URL(string: option.url)!)
            if canOpen {
                availableOptions.append(option)
            }
        }
        //Only one option, choose it right away
        if availableOptions.count == 1 || (controller == nil && !availableOptions.isEmpty){
            UIApplication.shared.open(URL(string:availableOptions[0].url)!)
            return
        }
        
        if controller != nil {
            let alert = UIAlertController(title: "Choose your navigation app", message: nil, preferredStyle: .alert)
            
            for option in availableOptions {
                alert.addAction(UIAlertAction(title: option.name, style: .default, handler: { action in
                    UIApplication.shared.open(URL(string:option.url)!)
                }))
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            controller?.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
}

enum LocationStatus {
    case notRequested
    case available
    case denied
}
