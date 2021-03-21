//
//  StartViewModel.swift
//  AirWatcher
//
//  Created by Daniel Łachacz on 15/11/2020.
//  Copyright © 2020 Daniel Łachacz. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class StartViewModel: ObservableObject {
    
    private var apiService: APIServiceProtocol?
    private var persistenceService: PersistenceServiceProtocol?
    let disposeBag = DisposeBag()
    public let saveingError: PublishSubject<Bool> = PublishSubject()
    var sensorsList = [Sensor]()
    var stationsList = [Station]()
    var addItemList = [AddItem]()
    var addItemList2 = [AddItem]()
    var sensorItemList = [SensorItem]()
    var dataList = [Data]()
    var dataList2 = [Data]()
    var dataItemList = [DataItem]()
    
    
    init(apiService: APIServiceProtocol = APIService(), persistenceService: PersistenceServiceProtocol = PersistenceService()) {
        self.apiService = apiService
        self.persistenceService = persistenceService
        fetchStations()
    }
    
     public func fetchStations() {
            guard let giosAllStationsURL = URL(string: "https://api.gios.gov.pl/pjp-api/rest/station/findAll") else {
                return
    }

            let stationsObservable = apiService?.fetchStations(url: giosAllStationsURL)
            
            stationsObservable?.subscribe(
                onNext: { (jsonResponse) in
                    //save downloaded data to the database
                    do {
                        try self.persistenceService?.addStations(stations: jsonResponse)
                        
                        if jsonResponse.count > 0 {
                        self.fetchSensors(stations: jsonResponse)
                        self.stationsList.append(contentsOf: jsonResponse)
                        }
                        else {
                            print("VM STATIONS: za malo")
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

           let sensorsObservable = apiService?.fetchSensors(url: giosAllSensorsURL)
            
            sensorsObservable?.subscribe(
                onNext: { (jsonResponse) in
                    self.sensorsList.append(contentsOf: jsonResponse)
                    
                    //save downloaded data to the database
                    if(index + 1 == ids.count) {
                        do {
                            try self.persistenceService?.addSensors(sensors: self.sensorsList)
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
            addItemList = try persistenceService!.fetchAddItems()
            if addItemList.count > 0 {
                fetchData(add: addItemList)
            }
            else if addItemList.count <= 0 {
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
        var dataArray = [Data]()
        
        for (index, x) in sensorIds {
            guard let giosDataURL = URL(string: "https://api.gios.gov.pl/pjp-api/rest/data/getData/\(x)") else {
                return
            }

            countIndex += [index]
            countId += [x]
            let stationId = stationIds[index]
          
            let dataObservable = apiService!.fetchData(url: giosDataURL)
            dataObservable.subscribe(
                onNext: { (jsonResponse) in
                    self.dataList += [jsonResponse]
                    let valuesArray = Array(jsonResponse.values)
                    let data = Data(id: x, stationId: stationId, key: jsonResponse.key, values: valuesArray)
                      
                    dataArray.append(data)
                    
                    if( self.dataList.count == countIndex.count) {
                        do {
                            try self.persistenceService!.addData(data: dataArray)
                        }
                        catch {
                            print("Error StartViewModel: in fetchData during saving the data")
                        }
                        self.saveingError.onNext(false)
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
    
//    func setStationItemsWithData(addItemList: [AddItem], dataItemList: [DataItem]) {
//        var stationItems = [AddItem]()
//        stationItems.append(contentsOf: addItemList)
//
//        let addItemSensors = stationItems.flatMap{$0.sensors}
//
//        dataItemList.forEach { data in
//            guard let index = addItemSensors.firstIndex(where: {$0.id == data.id})
//                else {
//                    print("Failed to find a AddItem for Data \(data.id)")
//                    return
//            }
//        }
//    }
    
}

