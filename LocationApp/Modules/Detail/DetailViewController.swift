//
//  DetailViewController.swift
//  LocationApp
//
//  Created by Bruno Aybar on 14/12/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class DetailViewController: SheetViewController {

    var place : Place?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var subLabel: UILabel!
    
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
              partial:200,
              scrollableView: tableView)
    }
    
    func setupPlace(){
        //Set name
        nameLabel.text = place?.name
        //TODO: Request event details
    }
    
    @IBAction func actionClose(_ sender: Any) {
        collapse(completely: true)
    }

}
