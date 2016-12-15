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
    @IBOutlet var optionsContainerView: UIView!
    
    internal let mViewModel = MainViewModel(source: Injection.getSource())
    internal let mDisposeBag = DisposeBag()
    internal var mPlaces : [Place] = []
    
    internal var listSheet : ListPlacesViewController?
    internal var detailSheet : DetailViewController?
    
    internal var currentAnnotation : MKPointAnnotation?
    internal var selectedAnnotation : MKAnnotation?
    
    @IBOutlet var placeMeButton: UIButton!
    @IBOutlet var cancelPickButton: UIButton!
    @IBOutlet var bouncingPinImageView: UIImageView!
    @IBOutlet var bouncingPinCenterYConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mViewModel.getPlacesStream().subscribe(onNext: { place in
            self.mPlaces.append(place)
            self.addAsAnnotation(place)
            if self.listSheet != nil{
                self.listSheet!.updated(places: self.mPlaces)
            }
            
        }).addDisposableTo(mDisposeBag)
        
        mViewModel.getCurrentLocationStream()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { location in
                self.relocate(coordinates: location)
            }).addDisposableTo(mDisposeBag)
        
        mViewModel.start()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSheets()
        setupPickLocationViews()
    }
    
    func openPlaceDetail(_ place: Place){
        if self.detailSheet != nil{
            removeSheetView(self.detailSheet!)
        }
        
        //Init view controller
        self.detailSheet = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController
        //Assign place
        self.detailSheet?.place = place
        //Present detail
        addBottomSheetView(self.detailSheet!)
    }
    
    
    // MARK: Place list sheet
    
    
    // MARK: IBActions
    
    @IBAction func actionLocation(_ sender: Any) {
        showLocationOptions()
    }
    
    @IBAction func actionSettings(_ sender: Any) {
    }
    
    @IBAction func actionPlaceMe(_ sender: Any) {
    }
    
    @IBAction func actionCancelPick(_ sender: Any) {
        pickLocation(start: false)
    }
    
}

//Location handling
extension ViewController {
    func showLocationOptions(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Current location", style: .default, handler: { a in
            self.mViewModel.requestedCurrentLocation()
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Pick location on map", style: .default, handler: { a in
            self.pickLocation(start: true)
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { a in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func setupPickLocationViews(){
        pickLocation(start: false)
        bouncingPinCenterYConstraint.constant -= 20
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat,.autoreverse], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func pickLocation(start: Bool){
        UIView.animate(withDuration: 0.5, animations: {
            self.setAnnotations(visible: !start)
            self.bouncingPinImageView.isHidden = !start
            self.cancelPickButton.isHidden = !start
            self.placeMeButton.isHidden = !start
            
            self.mapView.alpha = start ? 0.5 : 1
            self.optionsContainerView.isHidden = start
            self.listSheet?.view.isHidden = start
        })
    }
    
    func setAnnotations(visible: Bool){
        for annotation in mapView.annotations {
            mapView.view(for: annotation)?.isHidden = !visible
        }
    }
    
    
}

extension ViewController : MKMapViewDelegate{
    
    func relocate(coordinates: CLLocationCoordinate2D, zoom: Bool = true) {
        if currentAnnotation == nil {
            //Create annotation
            currentAnnotation = CurrentLocationAnnotation()
            currentAnnotation!.coordinate = coordinates
            self.mapView.addAnnotation(currentAnnotation!)
        }else{
            //Relocate current position
            currentAnnotation?.coordinate = coordinates
        }
        
        center(at: coordinates, zoom:zoom)
    }
    
    func center(at coordinate: CLLocationCoordinate2D, zoom: Bool = true){
        var viewRegion = self.mapView.region
        viewRegion.center = coordinate
        if zoom {
            viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 2500, 2500)
        }
        self.mapView.setRegion(viewRegion, animated: true)
    }
    
    func addAsAnnotation(_ place :Place){
        let annotation = PlaceAnnotation(with:place)
        self.mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pins"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }else{
            annotationView?.annotation = annotation
        }
        //For current location annotation
        if let currentAnnotation = annotation as? CurrentLocationAnnotation{
            annotationView?.canShowCallout = true
            annotationView?.image = currentAnnotation.image
        }
        //For place annotation
        if let placeAnnotation = annotation as? PlaceAnnotation{
            annotationView?.canShowCallout = true
            annotationView?.image = placeAnnotation.image
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        selectedAnnotation = view.annotation
        if let placeAnnotation = view.annotation as? PlaceAnnotation {
            let place = placeAnnotation.place
            //Center camera at selected place
            center(at: placeAnnotation.coordinate,zoom: false)
            //Animate image change
            UIView.transition(with: view, duration: 0.3, options: [.curveLinear,.allowAnimatedContent], animations: {
                view.image = placeAnnotation.imageSelected
            }, completion: nil)
            //Open place details
            openPlaceDetail(place)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if selectedAnnotation === view.annotation {
            selectedAnnotation = nil
        }
        if let placeAnnotation = view.annotation as? PlaceAnnotation {
            //Reset pin image
            UIView.transition(with: view, duration: 0.3, options: [.curveLinear,.allowAnimatedContent], animations: {
                view.image = placeAnnotation.image
            }, completion: nil)
            //Close detail
            detailSheet?.collapse(completely: true)
        }
    }
}

extension ViewController : SheetDelegate{
    // MARK: SheetDelegate implementation
    func sheetDidSelect(place: Place) {
        openPlaceDetail(place)
    }
    
    func sheetDidCollapse(controller: SheetViewController, completely: Bool) {
        if completely {
            //Remove sheet
            removeSheetView(controller)
            //Dereference detail is matches current
            if controller is DetailViewController && controller == detailSheet{
                detailSheet = nil
                if selectedAnnotation != nil {
                    mapView.deselectAnnotation(selectedAnnotation, animated: true)
                }
            }
        }
    }
    
    // MARK: Sheet-related functions
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
}
