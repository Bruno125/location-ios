//
//  SplashViewController.swift
//  LocationApp
//
//  Created by Bruno Aybar on 14/12/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet var iconWidthConstraint: NSLayoutConstraint!
    @IBOutlet var iconImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateIcon()
    }
    
    func animateIcon(){
        //Hide icon
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
    
    func replaceWithController(identifier:String){
        let vc = storyboard?.instantiateViewController(withIdentifier: identifier)
        present(vc!, animated: true, completion: nil)
    }

}
