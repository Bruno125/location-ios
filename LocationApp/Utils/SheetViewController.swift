//
//  SheetViewController.swift
//  LocationApp
//
//  Created by Bruno Aybar on 14/12/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

protocol SheetDelegate {
    func sheetDidExpand(controller: SheetViewController)
    func sheetDidCollapse(controller: SheetViewController, completely: Bool)
    func sheetDidSelect(place: Place)
}

extension SheetDelegate { //For optional functions
    func sheetDidExpand(controller: SheetViewController) {}
    func sheetDidCollapse(controller: SheetViewController, completely: Bool) {}
    func sheetDidSelect(place: Place) {}
}

class SheetViewController: UIViewController {

    
    var fullView: CGFloat = 300
    var partialView: CGFloat = 0
    var scrollableView : UIScrollView?
    var isBlurred = true
    var blurEffectStyle = UIBlurEffectStyle.light
    var delegate: SheetDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        //Add gesture to expand or collapse view
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
        
    }
    
    
    internal func setup(full: CGFloat, partial:CGFloat, scrollableView: UIScrollView? = nil, isBlurred: Bool = true, blurEffect: UIBlurEffectStyle? = .light){
        self.fullView = full
        self.partialView = partial
        self.scrollableView = scrollableView
        self.isBlurred = isBlurred
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Add blur background
        if isBlurred{
            prepareBackgroundView()
        }
    }
    
    func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: blurEffectStyle)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        
        let screenBounds = UIScreen.main.bounds
        let viewFrame = CGRect(x: screenBounds.minX, y: screenBounds.minY, width: screenBounds.width, height: partialView)
        visualEffect.frame = viewFrame
        bluredView.frame = viewFrame
        
        view.insertSubview(bluredView, at: 0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
        }
    }
    
    func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        
        let y = self.view.frame.minY
        if (y + translation.y >= fullView) && (y + translation.y <= partialView) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
                
            }, completion: { [weak self] _ in
                if ( velocity.y < 0 ) {
                    self?.scrollableView?.isScrollEnabled = true
                }
            })
        }
    }
    
    func collapse(completely: Bool = false){
        let y = completely ? UIScreen.main.bounds.height : partialView
        UIView.animate(withDuration: 0.3, animations: {
            let frame = self.view.frame
            self.view.frame = CGRect(x: 0, y: y, width: frame.width, height: frame.height)
        }, completion: { r in
            self.delegate?.sheetDidCollapse(controller: self, completely: completely)
        })
    }
    
}



extension SheetViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y
        
        let y = view.frame.minY
        if (y == fullView && scrollableView?.contentOffset.y == 0 && direction > 0) || (y == partialView) {
            scrollableView?.isScrollEnabled = false
        } else {
            scrollableView?.isScrollEnabled = true
        }
        
        return false
    }
    
}

