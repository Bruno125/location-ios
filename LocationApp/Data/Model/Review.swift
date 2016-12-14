//
//  Review.swift
//  LocationApp
//
//  Created by Bruno Aybar on 14/12/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Review {

    let authorName: String
    let rating: Double
    let timeDescription: String
    let text: String
    
    static func parse(json: JSON) -> Review{
        let authorName = json["author_name"].stringValue
        let timeDescription = json["relative_time_description"].stringValue
        let text = json["text"].stringValue
        
        let ratingArray = json["aspects"].arrayValue
        var rating = 0.0
        if ratingArray.count > 0 {
            rating = ratingArray[0]["rating"].doubleValue
        }
        
        return Review(authorName: authorName,
                      rating: rating,
                      timeDescription: timeDescription,
                      text: text)
        
    }
    
    
}
