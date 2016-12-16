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
    
    private static var categories : [PlaceType] = SettingsViewModel.defaultCategories()
    private static var radius = AppUtils.getRadius()
    
    private var tempCategories : [PlaceType] = []
    private var tempRadius = 0
    private var changed = false
    
    init(source :PlaceRepo){
        mSource = source
    }
    
    private static func defaultCategories() -> [PlaceType]{
        return [
            PlaceTypes.Atm(),
            PlaceTypes.Cafe(),
            PlaceTypes.Hospital(),
            PlaceTypes.Parking(),
            PlaceTypes.Restaurant(),
            PlaceTypes.TrainStation(),
            PlaceTypes.University(),
            PlaceTypes.Bank(),
            PlaceTypes.Library(),
            PlaceTypes.School(),
            PlaceTypes.Stadium()]
    }
    
    private let categoriesSubject = PublishSubject<[PlaceType]>()
    func getCategoriesStream() -> Observable<[PlaceType]>{
        return categoriesSubject.asObservable()
    }
    
    private let updateEnabledSubject = PublishSubject<Bool>()
    func getUpdateEnabledStream() -> Observable<Bool> {
        return updateEnabledSubject.asObservable()
    }
    
    func start(){
        tempCategories = SettingsViewModel.defaultCategories()
        for i in 0...tempCategories.count - 1 {
            tempCategories[i].selected = SettingsViewModel.categories[i].selected
        }
        
        tempRadius = SettingsViewModel.radius
        
        categoriesSubject.onNext(SettingsViewModel.categories)
        determineHasChanged()
    }
    
    func selected(index: Int){
        tempCategories[index].selected = !tempCategories[index].selected
        categoriesSubject.onNext(tempCategories)
        determineHasChanged()
    }
    
    func changedRadius(value: Int){
        tempRadius = value
        determineHasChanged()
    }
    
    func determineHasChanged(){
        updateEnabledSubject.onNext(hasMadeChanges())
    }
    
    func hasMadeChanges() -> Bool{
        //Check if has changed categories
        for i in 0...tempCategories.count-1{
            if tempCategories[i].selected != SettingsViewModel.categories[i].selected {
                return true
            }
        }
        //Check if has changed radius
        let radiusChanged = tempRadius != SettingsViewModel.radius
        return radiusChanged
    }
    
    func saveChanges(){
        //Save changes on static variables
        SettingsViewModel.categories = tempCategories
        SettingsViewModel.radius = tempRadius
        changed = true
    }
    
    func getResults() -> Observable<(changed: Bool, radius: Int,types: [PlaceType])>{
        //Create array only with selected categories
        var resultTypes = [PlaceType]()
        for category in tempCategories{
            if category.selected{
                resultTypes.append(category)
            }
        }
        //Return radius and selected categories
        return Observable.just((changed: changed, radius:tempRadius, types: resultTypes))
    }
    
}
