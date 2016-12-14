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
    
    @IBOutlet var mapView: MKMapView!
    
    private let mViewModel = MainViewModel(source: Injection.getSource())
    private let mDisposeBag = DisposeBag()
    private var mPlaces : [Place] = []
    
    private var listSheet : ListPlacesViewController?
    private var detailSheet : DetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mViewModel.getPlacesStream().subscribe(onNext: { place in
            self.mPlaces.append(place)
            self.addAsAnnotation(place)
            
            if self.listSheet != nil{
                self.listSheet!.updated(places: self.mPlaces)
            }
            
        }).addDisposableTo(mDisposeBag)
        
        mViewModel.start()
    }
    
    func addAsAnnotation(_ place :Place){
        let annotation = CustomAnnotationView()
        let centerCoordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude:place.longitude)
        annotation.coordinate = centerCoordinate
        annotation.title = place.name
        annotation.place = place
        self.mapView.addAnnotation(annotation)
    }
    
    func openPlaceDetail(_ place: Place){
        //Init view controller
        self.detailSheet = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController
        //Assign place
        self.detailSheet?.place = place
        //Present detail
        addBottomSheetView(self.detailSheet!)
    }
    
    // MARK: Place list sheet
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSheets()
        
    }
    
    func setupSheets(){
        //Add list of places view controller
        self.listSheet = storyboard?.instantiateViewController(withIdentifier: "List Places") as? ListPlacesViewController
        addBottomSheetView(self.listSheet!)
        self.listSheet!.updated(places: self.mPlaces)
        
        
    }
    
    func addBottomSheetView(_ bottomSheetVC: SheetViewController) {
        // Add self as delegate
        bottomSheetVC.delegate = self
        
        // Add bottomSheetVC as a child view
        self.addChildViewController(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParentViewController: self)
        
        // Adjust bottomSheet frame and initial position.
        let height = UIScreen.main.bounds.height
        let width  = UIScreen.main.bounds.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
        
        // 4- update sheet list
        self.listSheet!.updated(places: self.mPlaces)
    }
    
    func removeSheetView(_ sheetVC: SheetViewController){
        sheetVC.view.removeFromSuperview()
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

extension ViewController : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? CustomAnnotationView{
            if annotation.place != nil{
                openPlaceDetail(annotation.place!)
            }
        }
    }
}

extension ViewController : SheetDelegate{
    func sheetDidSelect(place: Place) {
        openPlaceDetail(place)
    }
    
    func sheetDidCollapse(controller: SheetViewController, completely: Bool) {
        if completely {
            //removeSheetView(controller)
        }
    }
}
