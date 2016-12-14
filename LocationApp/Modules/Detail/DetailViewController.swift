//
//  DetailViewController.swift
//  LocationApp
//
//  Created by Bruno Aybar on 14/12/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift

class DetailViewController: SheetViewController {

    var place : Place?
    let mViewModel = DetailViewModel(source: Injection.getSource())
    let mDisposeBag = DisposeBag()
    var requestedDetails = false
    var cellTypes = [DetailCellTypes]()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var subLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Check if place is assigned
        if place == nil {
            dismiss(animated: false, completion: nil)
            return
        }
        //Setup place
        setupPlace()
        
        //Setup sheet attributes
        setup(full: 80,
              partial: UIScreen.main.bounds.height - 170,
              scrollableView: tableView)
    }
    
    func setupPlace(){
        //Set name
        nameLabel.text = place?.name
        //Request event details
        mViewModel.getDetailsOnce(place: place!)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { place in
                self.place = place
                self.subLabel.text = place.vicinity
                self.requestedDetails = true
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }).addDisposableTo(mDisposeBag)
        
        
        activityIndicator.startAnimating()
    }
    
    @IBAction func actionClose(_ sender: Any) {
        collapse(completely: true)
    }

}

enum DetailCellTypes {
    case address
    case phone
    case website
    case photos
    case comments
    case commentsHeader
    case directions
    case none
    
}

extension DetailViewController : UITableViewDataSource,UITableViewDelegate{
    
    func calculateCells(for place: Place) -> Int {
        cellTypes = []
        
        cellTypes.append(.directions)
        
        if !place.name.isEmpty{
            cellTypes.append(.address)
        }
        if !place.internationalPhone.isEmpty{
            cellTypes.append(.phone)
        }
        if !place.website.isEmpty{
            cellTypes.append(.website)
        }
        
        if !place.photoUrls.isEmpty{
            cellTypes.append(.photos)
        }
        
        return cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestedDetails ? calculateCells(for: place!) : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        let type = cellTypes[indexPath.row]
        switch type {
        case .address:
            let tempCell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! SimpleTableViewCell
            tempCell.mainLabel.text = place!.address
            cell = tempCell
        case .phone:
            let tempCell = tableView.dequeueReusableCell(withIdentifier: "PhoneCell", for: indexPath) as! SimpleTableViewCell
            tempCell.mainLabel.text = place!.internationalPhone
            cell = tempCell
        case .website:
            let tempCell = tableView.dequeueReusableCell(withIdentifier: "WebsiteCell", for: indexPath) as! SimpleTableViewCell
            tempCell.mainLabel.text = place!.website
            cell = tempCell
        case .directions:
            cell = tableView.dequeueReusableCell(withIdentifier: "DirectionsCell", for: indexPath)
        case .photos:
            cell = tableView.dequeueReusableCell(withIdentifier: "PhotosCell", for: indexPath)
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}
