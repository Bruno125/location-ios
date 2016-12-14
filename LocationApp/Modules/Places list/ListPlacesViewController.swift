//
//  ListPlacesViewController.swift
//  LocationApp
//
//  Created by Bruno Aybar on 13/12/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class ListPlacesViewController: SheetViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var dividerView: UIView!
    
    var mPlaces : [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup(full: 300,
              partial: UIScreen.main.bounds.height - dividerView.frame.minY,
              scrollableView: tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsetsMake(0, 0, fullView, 0); //values

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.edgesForExtendedLayout = []
    }

    
}

extension ListPlacesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func updated(places: [Place]){
        self.mPlaces = places
        self.tableView.reloadData()
        /*self.mPlaces.append(place)
        //insert new row for new place
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath(row: mPlaces.count-1, section: 0)] , with: .automatic)
        self.tableView.endUpdates()*/
    }
    
    // MARK: View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Count: \(self.mPlaces.count)")
        return self.mPlaces.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell") as! PlaceTableViewCell
        cell.setPlace(self.mPlaces[indexPath.row])
        return cell
    }
    
    // MARK: View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Collapse list
        collapse()
        
        //Present place details
        let place = mPlaces[indexPath.row]
        self.delegate?.sheetDidSelect(place: place)
        
        //Deselect row
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
