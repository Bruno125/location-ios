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

    
    @IBOutlet var bottomToolbar: UIToolbar!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchButton: UIBarButtonItem!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var barToTableTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = PlaceRepository.sharedInstance.search("restaurant", type: .restaurant)
    }

    override func viewDidAppear(_ animated: Bool) {
        setupSearchTextField()
    }

    // MARK: Search
    
    @IBAction func actionSearch(_ sender: Any) {
        hideOrShowTableView()
    }
    
    func setupSearchTextField(){
        UIView.animate(withDuration: 0.5){
            let toolbarWidth = self.bottomToolbar.frame.width
            //Calculate search button size
            var searchSize = 0
            if let searchFrame = (self.searchButton.value(forKey: "view") as? UIView)?.frame{
                searchSize = Int(toolbarWidth) - Int(searchFrame.origin.x)
            }
            //Set frame to fit available space on toolbar
            var frame = self.searchTextField.frame
            frame.size.width = toolbarWidth - CGFloat(searchSize + 16) - frame.origin.x
            self.searchTextField.frame = frame
        }
    }
    
    func hideOrShowTableView() {
        barToTableTopConstraint.priority = barToTableTopConstraint.priority > 500 ? 250 : 900
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: Location
    
    
    @IBAction func actionLocation(_ sender: Any) {
    }
    
    @IBAction func actionFilter(_ sender: Any) {
    }
    
    

}

