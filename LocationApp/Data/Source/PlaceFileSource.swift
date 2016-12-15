//
//  PlaceFileSource.swift
//  LocationApp
//
//  Created by Bruno Aybar on 27/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import SwiftyJSON
import RxSwift

class PlaceFileSource: PlaceRepo {
    
    static let sharedInstance = PlaceFileSource()
    private init(){}
    
    func nearby(latitude: Double, longitude: Double, radius :Int, type: [PlaceType]) -> Observable<[Place]>{
        
        return Observable.create{ observer in
            do{
                //Read file
                let json = try self.readJsonFile(file: "place_search")
                //Parse file into places list
                let places = PlaceUtils.parseList(from: json["results"])
                //Return the list
                observer.onNext(places)
            }catch let error{
                //An error ocurred
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func getDetails(placeId: String) -> Observable<Place> {
        
        return Observable.create{ observer in
            do{
                //Read file
                let json = try self.readJsonFile(file: "place_detail")
                //Parse file into place details
                let place = PlaceUtils.parseDetail(from:json["result"])
                //Return the instace
                observer.onNext(place!)
            }catch let error{
                //An error ocurred
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func getPhotos(referenceNumber: String) -> Observable<[String]> {
        return Observable.just([])
    }
    
    private func readJsonFile(file: String) throws -> JSON{
        if let path = Bundle.main.path(forResource: file, ofType:"json"){
            do{
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                return JSON(data:data)
            }catch let error{
                throw error
            }
        }else{
            throw ReadFileError.invalidFile
        }
    }
}


enum ReadFileError : Error{
    case invalidFile
}
