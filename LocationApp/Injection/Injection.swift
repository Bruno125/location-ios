//
//  Injection.swift
//  LocationApp
//
//  Created by Bruno Aybar on 12/12/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class Injection: NSObject {
    
    static func getSource() -> PlaceRepo{
        return PlaceRepository.sharedInstance
    }
    
}
