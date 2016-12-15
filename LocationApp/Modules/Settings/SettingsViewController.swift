//
//  SettingsViewController.swift
//  LocationApp
//
//  Created by Bruno Aybar on 15/12/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class SettingsViewController: SheetViewController {

    internal let categories : [PlaceType] = [
        PlaceTypes.Atm(),
        PlaceTypes.Cafe(),
        PlaceTypes.Hospital(),
        PlaceTypes.Parking(),
        PlaceTypes.Restaurant(),
        PlaceTypes.TrainStation(),
        PlaceTypes.University(),
        PlaceTypes.Atm(),
        PlaceTypes.Cafe(),
        PlaceTypes.Hospital(),
        PlaceTypes.Parking(),
        PlaceTypes.Restaurant(),
        PlaceTypes.TrainStation(),
        PlaceTypes.University(),
        PlaceTypes.Atm(),
        PlaceTypes.Cafe(),
        PlaceTypes.Hospital(),
        PlaceTypes.Parking(),
        PlaceTypes.Restaurant(),
        PlaceTypes.TrainStation(),
        PlaceTypes.University()]
    
    @IBOutlet var collectionView: UICollectionView!
    var sizingCell : CategoryCollectionViewCell?
    @IBOutlet var flowLayout: CustomFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup(full: 150,
              partial: UIScreen.main.bounds.height - 300,
              scrollableView: collectionView)
        
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, fullView, 0);
        
        
        let cellNib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "CategoryCell")
        self.collectionView.backgroundColor = .clear
        
        self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! CategoryCollectionViewCell?
        self.flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    @IBAction func actionClose(_ sender: Any) {
        collapse(completely: true)
    }
    
}

extension SettingsViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        configure(cell: cell, forIndexPath: indexPath)
        return cell
    }
    
    
    func configure(cell: CategoryCollectionViewCell, forIndexPath indexPath: IndexPath) {
        let category = categories[indexPath.row]
        cell.mainLabel.text = category.name
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.configure(cell: self.sizingCell!, forIndexPath: indexPath)
        return self.sizingCell!.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }
}
