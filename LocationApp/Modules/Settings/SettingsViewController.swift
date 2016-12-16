//
//  SettingsViewController.swift
//  LocationApp
//
//  Created by Bruno Aybar on 15/12/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift

class SettingsViewController: SheetViewController {

    internal var mViewModel = SettingsViewModel(source:Injection.getSource())
    internal let mDisposeBag = DisposeBag()
    internal var categories : [PlaceType] = []
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var applyButton: UIButton!
    var sizingCell : CategoryCollectionViewCell?
    @IBOutlet var flowLayout: CustomFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let fixedSize = UIScreen.main.bounds.height - applyButton.frame.maxY - 10
        setup(full: fixedSize,
              partial: fixedSize,
              scrollableView: collectionView)
        
        setupCollectionView()
        
        mViewModel.getCategoriesStream()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { categories in
            self.categories = categories
            self.collectionView.reloadData()
        }).addDisposableTo(mDisposeBag)
        
        mViewModel.getUpdateEnabledStream()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ enabled in
                UIView.animate(withDuration: 0.3, animations: {
                    self.applyButton.isEnabled = enabled
                    self.applyButton.alpha = enabled ? 1 : 0.2
                    let title = enabled ? "Apply changes" : "You've made no changes"
                    self.applyButton.setTitle(title, for: .normal)
                })
//                self.applyButton.backgroundColor = enabled ? UIColor.enabledColor() : UIColor.disabledColor()
        }).addDisposableTo(mDisposeBag)
        
        mViewModel.start()
    }
    
    func setupCollectionView(){
        //Set inset for sheet behavior
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, fullView, 0);
        //Setup cells
        let cellNib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "CategoryCell")
        self.collectionView.backgroundColor = .clear
        //Setup for flowlayout
        self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! CategoryCollectionViewCell?
        self.flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
    }
    
    @IBAction func actionApply(_ sender: Any) {
        mViewModel.saveChanges()
        collapse(completely: true)
    }
    
    @IBAction func actionClose(_ sender: Any) {
        collapse(completely: true)
    }
    
    func getResults() -> Observable<(changed: Bool, radius: Int,types: [PlaceType])>{
        return mViewModel.getResults()
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
        cell.setUI(selected: category.selected)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        mViewModel.selected(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.configure(cell: self.sizingCell!, forIndexPath: indexPath)
        return self.sizingCell!.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }
}
