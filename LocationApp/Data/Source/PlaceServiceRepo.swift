//
//  PlaceServiceRepo.swift
//  LocationApp
//
//  Created by Bruno Aybar on 27/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire
import SwiftyJSON

class PlaceServiceRepo: PlaceRepo {
    
    static let sharedInstance = PlaceServiceRepo()
    private init(){}
    
    private static let API_KEY = AppUtils.getApiKey()
    private static let URL_BASE = AppUtils.getBaseUrl()
    private static let URL_NEARBY = "\(URL_BASE)/nearbysearch/json?location=%f,%f&radius=%d&key=\(API_KEY)"
    private static let URL_DETAILS = "\(URL_BASE)/details/json?placeid=%@&key=\(API_KEY)"
    private static let URL_PHOTO = "\(URL_BASE)/photo?photoreference=%@&key=\(API_KEY)"
    
    func nearby(latitude: Double, longitude: Double, radius :Int, type: PlaceTypes) -> Observable<[Place]>{

        return Observable.create { observer in
            let url = String(format:PlaceServiceRepo.URL_NEARBY,latitude,longitude,radius)
            let requestReference = Alamofire.request(url).responseJSON(completionHandler: { response in
                if let value = response.result.value {
                    //Parse response into SwiftyJSON
                    let json = JSON(value)
                    //Parse result
                    let places = PlaceUtils.parseList(from: json["results"])
                    //Return the list
                    observer.onNext(places)
                }else if let error = response.result.error{
                    observer.onError(error)
                }
            })
            
            return Disposables.create(with: { 
                requestReference.cancel()
            })
        }
        
    }
    
    func getDetails(placeId: String) -> Observable<Place> {
        return Observable.create { observer in
            let url = String(format:PlaceServiceRepo.URL_DETAILS,placeId)
            let requestReference = Alamofire.request(url).responseJSON(completionHandler: { response in
                if let value = response.result.value {
                    //Parse response into SwiftyJSON
                    let json = JSON(value)
                    //Parse result
                    var place = PlaceUtils.parseDetail(from: json["result"])
                    
                    if place == nil {
                        observer.onError(PlaceError.invalidResponse)
                    }else{
                        //Parse photo urls
                        var urls = [String]()
                        for reference in place!.photoReferences{
                            urls.append( String(format:PlaceServiceRepo.URL_PHOTO,reference) )
                        }
                        place!.photoUrls = urls
                        
                        //Return the list
                        observer.onNext(place!)
                    }
                    
                    
                    
                }else if let error = response.result.error{
                    observer.onError(error)
                }
            })
            
            return Disposables.create(with: {
                requestReference.cancel()
            })
        }
    }
    
    func getPhotos(referenceNumber: String) -> Observable<[String]> {
        return Observable.just([])
    }
    
}

enum PlaceError : Error{
    case invalidResponse
}
