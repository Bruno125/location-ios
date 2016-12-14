//
//  DetailViewModel.swift
//  LocationApp
//
//  Created by Bruno Aybar on 14/12/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift

class DetailViewModel {

    
    private let mSource :PlaceRepo
    private let mDisposeBag = DisposeBag()
    
    init(source :PlaceRepo){
        mSource = source
    }

    func getDetailsOnce(place: Place) -> Observable<Place>{
        return mSource.getDetails(placeId: place.id)
    }
    
}
