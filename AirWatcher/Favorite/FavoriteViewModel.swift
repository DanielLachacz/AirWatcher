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
    public let addItemArrayBS = BehaviorSubject<[AddItem]>(value: [])
    var addArray = [AddItem]()
    var stationArray = [Station]()
    var sensorArray = [Sensor]()
    var dataArray = [AirData]()
    var favoriteItemArrayBS = BehaviorSubject<[FavoriteItem]>(value: []) //usun w tym
    let disposeBag = DisposeBag()
    public let saveingError: PublishSubject<Bool> = PublishSubject()
    
    init(apiService: APIServiceProtocol = APIService(), persistenceService: PersistenceServiceProtocol = PersistenceService()) {
        self.apiService = apiService
        self.persistenceService = persistenceService
    }
    
    func fetchSavedAddItemsAndData() {
        var dataArray = [AirData]()
        do {
            addArray = try persistenceService.fetchAddItems().toArray(ofType: AddItem.self)
        } catch  {
            print("ERROR fetchAddItemsAndData FavoriteViewModel")
        }
        
        do {
            dataArray = try persistenceService.fetchData().toArray(ofType: AirData.self)
        } catch {
            print("ERROR fetchAddItemsAndData FavoriteViewModel")
        }
        setFavoriteSensors(addArray: addArray, dataArray: dataArray)
    }
    
    func setFavoriteSensors(addArray: [AddItem], dataArray: [AirData]) {
        var favoriteSensorArray = [FavoriteSensor]()
        let addSensors = addArray.flatMap{$0.sensors}
        var favoriteItemArray = [FavoriteItem]()
        
        let favoriteItem = addArray.map{ item in
            FavoriteItem(id: item.id,
                         cityName: item.cityName,
                         addressStreet: item.addressStreet,
                         sensors: [])
        }
        favoriteItemArray.append(contentsOf: favoriteItem)
        
        dataArray.forEach { data in
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
            
            favoriteSensorArray.append(favoriteSensor)
        }
        
        favoriteSensorArray.forEach { sensor in
            guard let index = favoriteItemArray.firstIndex(where: {$0.id == sensor.stationId}) else {
                print("Failed to find an item for sensor \(sensor.id)")
                return
            }
            favoriteItemArray[index].sensors.append(sensor)
        }
        self.favoriteItemArrayBS.onNext(favoriteItemArray)
        
    }
    
    func setFavoriteItems(data: [AirData]) {
        var addList2 = [AddItem]()
        var favoriteItems = [FavoriteItem]()
        
        do {
                addList2 = try persistenceService.fetchAddItems().toArray(ofType: AddItem.self)
        } catch {
                   print("ERROR setFavoriteItems FavoriteViewModel")
        }
       
        let favorite = addList2.map { add in
            FavoriteItem(id: add.stationId, cityName: add.cityName, addressStreet: add.addressStreet, sensors: [])
        }
        favoriteItems.append(contentsOf: favorite)
        
    }
    
    func deleteAddItem(indexPath: IndexPath) {
        //Find StationItem in the list and delete from the database
        let addItem = addArray[indexPath.row]
        do {
            try self.persistenceService.deleteAddItem(addItem: addItem)
            //to nizej wywala blad, mowiacy ze obiekt zostal usuniety. Wiec albo to obejsc albo cos innego
            //2. Skoro filter tak dziala, to moze da sie tego uzyc przy liscie add?
           // favoriteList.onNext(try favoriteList.value().filter {$0.id == addItem.id})
        }
        catch {
            print("Error FavoriteViewModel: deleteStationItem")
        }
    }
    
    //These methods below are just copied from the StartViewViewModel. I am sure, there is a better solution, but you know, laziness...
    public func fetchStations() {
               guard let giosAllStationsURL = URL(string: "https://api.gios.gov.pl/pjp-api/rest/station/findAll") else {
                   return
       }

               let stationsObservable = apiService.fetchStations(url: giosAllStationsURL)
               
               stationsObservable.subscribe(
                   onNext: { (jsonResponse) in
                       //save downloaded data to the database
                       do {
                           try self.persistenceService.addStations(stations: jsonResponse)
                           
                           if jsonResponse.count > 0 {
                           self.fetchSensors(stations: jsonResponse)
                           self.stationArray.append(contentsOf: jsonResponse)
                           }
                           else {
                               print("StartViewModel fetchStations: no data")
                           }
                       }
                       catch {
                           print("Error StartViewModel: in fetchStations saving error")
                       }
               },
                   onError: { (error) in
                       print("StartViewModel Error: fetchStations \(error)")
               },
                   onCompleted: {
                       print("StartViewModel Completed: fetchStations")
               },
                   onDisposed: {
                       print("StartViewModel Disposed: fetchStations")
                   }).disposed(by: disposeBag)

           }
    
    func fetchSensors(stations: [Station]) {
        // get only id numbers from the Station array
        let ids = stations.map{ $0.id }
        
        if (ids.count > 0) {
            
            for (index, id) in ids.enumerated() {
                
                guard let giosAllSensorsURL = URL(string: "https://api.gios.gov.pl/pjp-api/rest/station/sensors/\(id)") else {
                    return
                }
                
                let sensorsObservable = apiService.fetchSensors(url: giosAllSensorsURL)
                
                sensorsObservable.subscribe(
                    onNext: { (jsonResponse) in
                        self.sensorArray.append(contentsOf: jsonResponse)
                        
                        //save downloaded data to the database
                        if(index + 1 == ids.count) {
                            do {
                                try self.persistenceService.addSensors(sensors: self.sensorArray)
                                self.fetchSavedAddItems()
                            }
                            catch {
                                print("Error StartViewModel: in fetchStations saving error")
                                self.saveingError.onNext(true)
                            }
                        }
                },
                    onError: { (error) in
                        print("StartViewModel Error: fetchSensor \(error)")
                },
                    onCompleted: {
                        print("StartViewModel Completed: fetchSensor")
                },
                    onDisposed: {
                        print("StartViewModel Disposed: fetchSensor")
                }).disposed(by: disposeBag)
                
            }
            
        } else {
            print("START VM: Stations list is empty. I can't download the sensors list")
        }
    }
    
    func fetchSavedAddItems() {
        do {
            addArray = try persistenceService.fetchAddItems().toArray(ofType: AddItem.self)
            if addArray.count > 0 {
                fetchData(add: addArray)
            }
            else if addArray.count <= 0 {
                 self.saveingError.onNext(false)
            }
        } catch {
            print("ERROR fetchedSavedAddItems StartViewModel")
        }
    }
    
    func fetchData(add: [AddItem]) {
        let sensorIds = add.map{aStation in aStation.sensors.map{ $0.id}}.flatMap{$0}.enumerated()
        let stationIds = add.map{aStation in aStation.sensors.map{$0.stationId}}.flatMap{$0}
        var countIndex = [Int]()
        var countId = [Int]()
        var dataArray = [AirData]()
        
        for (index, x) in sensorIds {
            guard let giosDataURL = URL(string: "https://api.gios.gov.pl/pjp-api/rest/data/getData/\(x)") else {
                return
            }

            countIndex += [index]
            countId += [x]
            let stationId = stationIds[index]
          
            let dataObservable = apiService.fetchData(url: giosDataURL)
            dataObservable.subscribe(
                onNext: { (jsonResponse) in
                    self.dataArray += [jsonResponse]
                    let valuesArray = Array(jsonResponse.values)
                    let data = AirData(id: x, stationId: stationId, key: jsonResponse.key, values: valuesArray)
                      
                    dataArray.append(data)
                    
                    if( self.dataArray.count == countIndex.count) {
                        do {
                            try self.persistenceService.addData(data: dataArray)
                        }
                        catch {
                            print("Error StartViewModel: in fetchData during saving the data")
                        }
                        self.saveingError.onNext(false)
                        self.fetchSavedAddItemsAndData()
                    }
            },
                onError: { (error) in
                    print("StartViewModel Error: fetchData \(error)")
            },
                onCompleted: {
                    print("StartViewModel Completed: fetchData")
            },
                onDisposed: {
                    print("StartViewModel Disposed: fetchData")
                }).disposed(by: disposeBag)
        }
    }
    
    
}

