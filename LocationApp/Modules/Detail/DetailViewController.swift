//
//  DetailViewController.swift
//  LocationApp
//
//  Created by Bruno Aybar on 14/12/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift
import MapKit

class DetailViewController: SheetViewController {

    var place : Place?
    let mViewModel = DetailViewModel(source: Injection.getSource())
    let mDisposeBag = DisposeBag()
    var requestedDetails = false
    var cellTypes = [(type:DetailCellTypes,index:Int)]()
    
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
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, fullView, 0); //values
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
        
        cellTypes.append((.directions,0))
        
        if !place.photoUrls.isEmpty{
            cellTypes.append((.photos,0))
        }
        
        if !place.name.isEmpty{
            cellTypes.append((.address,0))
        }
        if !place.internationalPhone.isEmpty{
            cellTypes.append((.phone,0))
        }
        if !place.website.isEmpty{
            cellTypes.append((.website,0))
        }
        
        if !place.reviews.isEmpty {
            cellTypes.append((.commentsHeader,0))
            for i in 0...place.reviews.count-1{
                cellTypes.append((.comments,i))
            }
        }
        
        return cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestedDetails ? calculateCells(for: place!) : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        let type = cellTypes[indexPath.row].type
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
            let tempCell = tableView.dequeueReusableCell(withIdentifier: "DirectionsCell", for: indexPath) as! DirectionsTableViewCell
            tempCell.controller = self
            tempCell.location = CLLocationCoordinate2D(latitude: place!.latitude, longitude: place!.longitude)
            cell = tempCell
        case .photos:
            let tempCell = tableView.dequeueReusableCell(withIdentifier: "PhotosCell", for: indexPath) as! PhotoTableViewCell
            tempCell.set(photos: place!.photoUrls)
            cell = tempCell
        case .commentsHeader:
            cell = tableView.dequeueReusableCell(withIdentifier: "CommentHeaderCell", for: indexPath)
        case .comments:
            let tempCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
            let reviewIndex = cellTypes[indexPath.row].index
            let review = place!.reviews[reviewIndex]
            tempCell.commentLabel.text = review.text
            tempCell.authorLabel.text = review.authorName
            cell = tempCell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
