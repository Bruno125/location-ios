//
//  PlaceFileSource.swift
//  LocationApp
//
//  Created by Bruno Aybar on 27/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import SwiftyJSON

class PlaceFileSource: PlaceRepo {
    
    static let sharedInstance = PlaceFileSource()
    private init(){}
    
    func search(_ query: String, type: PlaceTypes) -> [Place] {
        do{
            let json = try self.readJsonFile(file: "place_search")
            
        }catch let error{
//            observer.onError(error)
        }
        
        return []
    }
    
    func getDetails(placeId: String) -> Place {
        return Place(id: "",name: "", latitude: 0, longitude: 0, description: "", distance: 0, photoReferences: [], photoUrls: [])
    }
    
    func getPhotos(referenceNumber: String) -> [String] {
        return []
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
