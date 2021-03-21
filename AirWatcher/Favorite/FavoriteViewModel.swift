//
//  FavoriteViewModel.swift
//  AirWatcher
//
//  Created by Daniel Łachacz on 15/11/2020.
//  Copyright © 2020 Daniel Łachacz. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class FavoriteViewModel: ObservableObject {
    
    private var apiService : APIServiceProtocol
    private let persistenceService: PersistenceServiceProtocol
    public let addItems = BehaviorSubject<[AddItem]>(value: [])
    public let favoriteItems = BehaviorSubject<[FavoriteItem]>(value: [])
    var addList = [AddItem]()
    var favoriteList = BehaviorSubject<[FavoriteItem]>(value: [])
    let disposeBag = DisposeBag()
    
    init(apiService: APIServiceProtocol = APIService(), persistenceService: PersistenceServiceProtocol = PersistenceService()) {
        self.apiService = apiService
        self.persistenceService = persistenceService
    }
    
    func fetchSavedAddItemsAndData() {
        //var addList = [AddItem]()
        var dataList = [Data]()
        do {
            addList = try persistenceService.fetchAddItems()
            print("addList fetchSavedAddItemsAndData: \(addList.count)")
        } catch  {
            print("ERROR fetchAddItemsAndData FavoriteViewModel")
        }
        
        do {
            dataList = try persistenceService.fetchData()
        } catch {
            print("ERROR fetchAddItemsAndData FavoriteViewModel")
        }
        setFavoriteSensors(addList: addList, dataList: dataList)
    }
    
    func setFavoriteSensors(addList: [AddItem], dataList: [Data]) {
        var favoriteSensorList = [FavoriteSensor]()
        let addSensors = addList.flatMap{$0.sensors}
        var favoriteItemList = [FavoriteItem]()
        
        let favoriteItem = addList.map{ item in
            FavoriteItem(id: item.id,
                         cityName: item.cityName,
                         addressStreet: item.addressStreet,
                         sensors: [])
        }
        favoriteItemList.append(contentsOf: favoriteItem)
        
        dataList.forEach { data in
            guard let sensor = addSensors.first(where: { $0.id == data.id}) else {
                print("Failed to find a Sensor for the Data \(data.id)")
                return
            }
            let favoriteSensor = FavoriteSensor(
                id: sensor.id,
                stationId: sensor.stationId,
                data: FavoriteData(
                    id: data.id,
                    key: data.key,
                    values: [FavoriteValue(
                        date: data.values.first?.date ?? "",
                        value: data.values.first?.value.value ?? 0)]))
            
            favoriteSensorList.append(favoriteSensor)
        }
        
        favoriteSensorList.forEach { sensor in
            guard let index = favoriteItemList.firstIndex(where: {$0.id == sensor.stationId}) else {
                print("Failed to find an item for sensor \(sensor.id)")
                return
            }
            favoriteItemList[index].sensors.append(sensor)
        }
        self.favoriteList.onNext(favoriteItemList)
        
    }
    
    func setFavoriteItems(data: [Data]) {
        var addList2 = [AddItem]()
        var favoriteItems = [FavoriteItem]()
        
        do {
                addList2 = try persistenceService.fetchAddItems()
        } catch {
                   print("ERROR setFavoriteItems FavoriteViewModel")
        }
       
        let favorite = addList2.map { add in
            FavoriteItem(id: add.stationId, cityName: add.cityName, addressStreet: add.addressStreet, sensors: [])
        }
        favoriteItems.append(contentsOf: favorite)
        
    }
    
    func deleteStationItem(indexPath: IndexPath) {
        
        //Find StatioItem in the list and change the value to inform TableView about changes
//        guard let sections = try? addItems.value() else { return }
//        
//        //sections.remove(at: indexPath.row)
//        addItems.onNext(sections)
        
        //Find StationItem in the list and delete from the database
        let addItem = addList[indexPath.row]
        do {
            try self.persistenceService.deleteStationItem(stationItem: addItem)
        }
        catch {
            print("Error FavoriteViewModel: deleteStationItem")
        }
    }
    
}

