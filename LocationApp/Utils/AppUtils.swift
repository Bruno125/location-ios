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
    
    func goToSettings(){
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
    }
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

