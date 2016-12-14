//
//  PhotoTableViewCell.swift
//  LocationApp
//
//  Created by Bruno Aybar on 14/12/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet var collectionView: UICollectionView!
    
    var mPhotos = [String]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(photos: [String]){
        mPhotos = photos
        collectionView.dataSource = self
        collectionView.reloadData()
    }

}


extension PhotoTableViewCell : UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let url = mPhotos[indexPath.row] + "&maxwidth=200"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell", for: indexPath) as! PhotoItemCollectionViewCell
        cell.photoImageView.downloadedFrom(link: url,contentMode: .scaleAspectFill)
        return cell
        
    }
    
}
