//
//  SettingsViewModel.swift
//  LocationApp
//
//  Created by Bruno Aybar on 15/12/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift

class SettingsViewModel {
    
    private let mSource :PlaceRepo
    private let mDisposeBag = DisposeBag()
    private static var categories : [PlaceType] = []
    
    init(source :PlaceRepo){
        mSource = source
        
    }
    
    private let categoriesSubject = PublishSubject<[PlaceType]>()
    func getCategoriesStream() -> Observable<[PlaceType]>{
        if SettingsViewModel.categories.isEmpty {
            SettingsViewModel.categories =  [
                PlaceTypes.Atm(),
                PlaceTypes.Cafe(),
                PlaceTypes.Hospital(),
                PlaceTypes.Parking(),
                PlaceTypes.Restaurant(),
                PlaceTypes.TrainStation(),
                PlaceTypes.University()]
        }
        
        return categoriesSubject.asObservable()
    }
    
    func start(){
        categoriesSubject.onNext(SettingsViewModel.categories)
    }
    
    func selected(index: Int){
        SettingsViewModel.categories[index].selected = !SettingsViewModel.categories[index].selected
        categoriesSubject.onNext(SettingsViewModel.categories)
    }
    
    func getResults(radius: Int ) -> Observable<(radius: Int,types: [PlaceType])>{
        var resultTypes = [PlaceType]()
        for category in SettingsViewModel.categories{
            if category.selected{
                resultTypes.append(category)
            }
        }
        //TODO: transform radius
        let calculatedRadius = 100
        
        return Observable.just((radius:calculatedRadius, types: resultTypes))
    }
    
}
