//
//  SplashViewController.swift
//  LocationApp
//
//  Created by Bruno Aybar on 14/12/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift

class SplashViewController: UIViewController {

    @IBOutlet var iconWidthConstraint: NSLayoutConstraint!
    @IBOutlet var iconImageView: UIImageView!
    
    @IBOutlet var locationImageView: UIImageView!
    @IBOutlet var locationWidthConstraint: NSLayoutConstraint!
    @IBOutlet var locationCenterYConstraint: NSLayoutConstraint!
    @IBOutlet var permissionHintView: UIView!
    @IBOutlet var hintLabel: UILabel!
    @IBOutlet var grantLocationButton: UIButton!
    
    private var mStatus = LocationStatus.notRequested
    private let mDisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        LocationUtils.sharedInstance.getLocationStatus()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ status in
                self.handleStatus(status)
            }).addDisposableTo(mDisposeBag)
        
        
    }
    
    func handleStatus(_ status: LocationStatus){
        self.mStatus = status
        switch status {
        case .available:
            self.redirectToMain()
        default:
            self.requestPermission()
        }

    }
    
    func redirectToMain(){
        //Reduce icon
        iconWidthConstraint.constant = 0
        UIView.animate(withDuration: 0.5, delay:1, animations: {
            self.view.layoutIfNeeded()
        }, completion: { c in
            //Present main view controller
            self.delay(time: 0, closure: {
                self.replaceWithController(identifier: "Main")
            })
        })
    }
    
    
    func requestPermission(){
        //Show message depending on current status
        if mStatus == .denied {
            self.hintLabel.text = "Please enable the location permission to continue using the app"
            self.grantLocationButton.setTitle("Go to settings", for: .normal)
        }else {
            self.hintLabel.text = "We need your location permission before continuing."
            self.grantLocationButton.setTitle("Grant location permission", for: .normal)
        }
        
        
        //Hide icon
        UIView.animate(withDuration: 0.5, delay:1, animations: {
            self.iconImageView.alpha = 0
            self.locationImageView.alpha = 1
        }, completion: { c in
            //Rotate location image
            let degrees:CGFloat = -45
            UIView.animate(withDuration: 0.5, animations: {
                self.locationImageView.transform = CGAffineTransform(rotationAngle: degrees * CGFloat(M_PI/180) )
            }, completion: { c in
                //Make location icon BIGGER and move UP
                self.locationWidthConstraint.constant = 180
                self.locationCenterYConstraint.constant = -40
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                },completion: { c in
                    UIView.animate(withDuration: 0.5, animations: {
                        self.permissionHintView.alpha = 1
                    })
                })
            })
            
            
            
        })
    }
    
    @IBAction func actionGrantPermission(_ sender: Any) {
        if mStatus == .denied {
            //Redirect to settings
            goToSettings()
        }else {
            LocationUtils.sharedInstance.request()
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { status in
                    self.handleStatus(status)
                }).addDisposableTo(mDisposeBag)
        }
        
    }
    
    func replaceWithController(identifier:String){
        let vc = storyboard?.instantiateViewController(withIdentifier: identifier)
        present(vc!, animated: true, completion: nil)
    }

}
