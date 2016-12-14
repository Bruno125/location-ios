//
//  Place.swift
//  LocationApp
//
//  Created by Bruno Aybar on 27/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Place {
    let id :String
    let name :String
    let latitude :Double
    let longitude :Double
    let vicinity : String
    
    let icon :String
    let address :String
    let phone :String
    let internationalPhone :String
    let rating :Double
    var distance :Double
    
    var photoReferences :[String] = []
    var photoUrls : [String] = []
    
    
}


struct PlaceUtils{
    
    static func parseList(from json: JSON) -> [Place]{
        return json.arrayValue.flatMap{ PlaceUtils.parseDetail(from: $0)}
    }
    
    static func parseDetail(from json :JSON) -> Place?{
        let id = json["place_id"].stringValue
        let name = json["name"].stringValue
        let vicinity = json["vicinity"].stringValue
        
        let icon = json["icon"].stringValue
        let address = json["formatted_address"].stringValue
        let phone = json["formatted_phone_number"].stringValue
        let internationalPhone = json["international_phone_number"].stringValue
        let rating = json["rating"].doubleValue
        let distance = 0.0
        
        let location = json["geometry"]["location"]
        let latitude = location["lat"].doubleValue
        let longitude = location["lng"].doubleValue

        let photoReferences = json["photos"].arrayValue.map{ $0["photo_reference"].stringValue }
        
        return Place(id: id,
                     name: name,
                     latitude: latitude,
                     longitude: longitude,
                     vicinity: vicinity,
                     icon: icon,
                     address: address,
                     phone: phone,
                     internationalPhone: internationalPhone,
                     rating: rating,
                     distance: distance,
                     photoReferences: photoReferences,
                     photoUrls: [])
    }
}
