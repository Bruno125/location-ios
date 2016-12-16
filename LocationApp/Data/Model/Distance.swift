//
//  Distance.swift
//  LocationApp
//
//  Created by Bruno Aybar on 16/12/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Distance {
    
    let originAddress: String
    let destinationAddress: String
    let duration: String
    let distance: String

}

class DistanceUtils{
    
    static func parse(json: JSON) -> [Distance]{
        let originAddresses = json["origin_addresses"].arrayValue.map {$0.stringValue}
        let destinationAddresses = json["destination_addresses"].arrayValue.map {$0.stringValue}
        let rows = json["rows"].arrayValue.map { $0["elements"].arrayValue }
        var results = [Distance]()
        
        for i in 0...rows.count-1{
            for k in 0...rows[i].count-1{
                let origin = originAddresses[i]
                let destination = destinationAddresses[k]
                let duration = rows[i][k]["duration"]["text"].stringValue
                let distance = rows[i][k]["distance"]["text"].stringValue
                
                results.append(Distance(originAddress: origin,
                                        destinationAddress: destination,
                                        duration: duration,
                                        distance: distance))
                
            }
        }
        return results
    }
    
}
