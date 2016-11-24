//
//  ViewController.swift
//  LocationApp
//
//  Created by Bruno Aybar on 24/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var barToTableTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        actionTest(mapView)
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func actionTest(_ sender: Any) {
        barToTableTopConstraint.priority = barToTableTopConstraint.priority > 500 ? 250 : 900
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
        
    }
    
    

}

