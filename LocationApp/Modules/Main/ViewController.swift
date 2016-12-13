//
//  ViewController.swift
//  LocationApp
//
//  Created by Bruno Aybar on 24/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import MapKit
import RxSwift

class ViewController: UIViewController {

    
    @IBOutlet var bottomToolbar: UIToolbar!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchButton: UIBarButtonItem!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var barToTableTopConstraint: NSLayoutConstraint!
    
    private let mViewModel = MainViewModel(source: Injection.getSource())
    private let mDisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mViewModel.getPlacesStream().subscribe(onNext: { place in
            let annotation = MKPointAnnotation()
            let centerCoordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude:place.longitude)
            annotation.coordinate = centerCoordinate
            annotation.title = place.name
            self.mapView.addAnnotation(annotation)
        }).addDisposableTo(mDisposeBag)
        
        
        mViewModel.start()
    }
    
    // MARK: Place list sheet
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //setupSearchTextField()
        addBottomSheetView()
    }
    
    func addBottomSheetView() {
        // 1- Init bottomSheetVC
        let bottomSheetVC = storyboard?.instantiateViewController(withIdentifier: "List Places") as! ListPlacesViewController
        
        // 2- Add bottomSheetVC as a child view
        self.addChildViewController(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParentViewController: self)
        
        // 3- Adjust bottomSheet frame and initial position.
        let height = UIScreen.main.bounds.height
        let width  = UIScreen.main.bounds.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
    
    // MARK: Location
    
    @IBAction func actionLocation(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Current location", style: .default, handler: { a in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Pick location on map", style: .default, handler: { a in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "By postcode", style: .default, handler: { a in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { a in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    // MARK: Settings
    
    
    @IBOutlet var actionSettings: UIButton!

}

