//
//  AppUtils.swift
//  LocationApp
//
//  Created by Bruno Aybar on 12/12/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class AppUtils: NSObject {
    
    
    static func getBaseUrl() -> String{
        return Bundle.main.object(forInfoDictionaryKey: "Base URL") as! String
    }
    
    
    static func getApiKey() -> String{
        return Bundle.main.object(forInfoDictionaryKey: "Google Api Key") as! String
    }
    
    
    static func getRadius() -> Int{
        return 10000 // TODO: get from preferences
    }
    
}

extension UIViewController {
    func delay(time: Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: when) {
            closure()
        }
        
    }
}
