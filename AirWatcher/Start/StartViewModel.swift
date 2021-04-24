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
    
    private var apiService: APIServiceProtocol
    private var persistenceService: PersistenceServiceProtocol?
    let disposeBag = DisposeBag()
    public let saveingError: PublishSubject<Bool> = PublishSubject()
    var sensorArray = [Sensor]()
    var addItemArray = [AddItem]()
    var addItemArray2 = [AddItem]()
    var sensorItemArray = [SensorItem]()
    var dataArray = [Data]()
    var dataArray2 = [Data]()
    var dataItemArray = [DataItem]()
    var airQualityIndexArray = [AirQualityIndex]()
    
    
    init(apiService: APIServiceProtocol = APIService(), persistenceService: PersistenceServiceProtocol = PersistenceService()) {
        self.apiService = apiService
        self.persistenceService = persistenceService
        fetchStations()
    }
    
     public func fetchStations() {
            guard let giosAllStationsURL = URL(string: "https://api.gios.gov.pl/pjp-api/rest/station/findAll") else {
                return
    }

            let stationsObservable = apiService.fetchStations(url: giosAllStationsURL)
            
            stationsObservable.subscribe(
                onNext: { (jsonResponse) in
                    //save downloaded data to the database
                    do {
                        try self.persistenceService?.addStations(stations: jsonResponse)
                        
                        if jsonResponse.count > 0 {
                        self.fetchSensors(stations: jsonResponse)
                        self.fetchAirQualityIndex(stations: jsonResponse)
                        }
                        else {
                            print("StartViewModel Error: fetchStations not enough jsonResponse.count")
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
                            try self.persistenceService?.addSensors(sensors: self.sensorArray)
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
            addItemArray = try persistenceService!.fetchAddItems().toArray(ofType: AddItem.self)
            if addItemArray.count > 0 {
                fetchData(add: addItemArray)
            }
            else if addItemArray.count <= 0 {
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
          
            let dataObservable = apiService.fetchData(url: giosDataURL)
            dataObservable.subscribe(
                onNext: { (jsonResponse) in
                    self.dataArray += [jsonResponse]
                    let valuesArray = Array(jsonResponse.values)
                    let data = Data(id: x, stationId: stationId, key: jsonResponse.key, values: valuesArray)
                      
                    dataArray.append(data)
                    
                    if( self.dataArray.count == countIndex.count) {
                        do {
                            try self.persistenceService!.addData(data: dataArray)
                        }
                        catch {
                            print("Error StartViewModel: in fetchData during saving the data")
                        }
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
    
    func fetchAirQualityIndex(stations: [Station]) {
        let ids = stations.map{ $0.id }
        var countIndex = [Int]()
        
        for (index, id) in ids.enumerated() {
            guard let airQualityIndexURL = URL(string: "https://api.gios.gov.pl/pjp-api/rest/aqindex/getIndex/\(id)") else {
                return
            }
            countIndex += [index]
            
            let airQualityIndexObservable = apiService.fetchAirQualityIndex(url: airQualityIndexURL)
            airQualityIndexObservable.subscribe(
                onNext: { (jsonResponse) in
                    self.airQualityIndexArray += [jsonResponse]
                    
                    if self.airQualityIndexArray.count == countIndex.count {
                        do {
                            try self.persistenceService!.addAirQualityIndex(air: self.airQualityIndexArray)
                        }
                        catch {
                            print("Error StartViewModel: in fetchData during saving the data")
                        }
                        self.saveingError.onNext(false)
                    }
            },
                onError: { (error) in
                    print("MapViewModel Error: fetchAirQualityIndex \(error)")
            },
                onCompleted: {
                    print("MapViewModel Completed: fetchAirQualityIndex")
            },
                onDisposed: {
                    print("MapViewModel Disposed: fetchAirQualityIndex")
                }).disposed(by: disposeBag)
        }
    }
    
}

