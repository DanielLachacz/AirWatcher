//
//  AddViewModel.swift
//  AirWatcher
//
//  Created by Daniel Łachacz on 30/11/2020.
//  Copyright © 2020 Daniel Łachacz. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class AddViewModel {
    
    private var persistenceService: PersistenceServiceProtocol
    private let stations = PublishSubject<[Station]>()
    private let sensors = PublishSubject<[Sensor]>()
    var addItems = PublishSubject<[AddItem]>()
    var stationList = [Station]()
    var sensorList = [Sensor]()
    let disposeBag = DisposeBag()
    let addItem = PublishSubject<AddItem>()
    
    init(persistenceService: PersistenceServiceProtocol =
    PersistenceService()) {
        self.persistenceService = persistenceService
    }
    
    func fetchSavedStations() {
        do {
            stationList += try persistenceService.fetchStations()
            self.stations.onNext(stationList)
        } catch {
            print("ERROR fetchStations AddViewModel")
        }
        
        fetchSavedSensors()
        if stationList.count > 0 && sensorList.count > 0 {
            setAddItemList(stations: stationList, sensors: sensorList)
        }
    }
    
    func fetchSavedSensors() {
        do {
            sensorList += try persistenceService.fetchSensors()
            self.sensors.onNext(sensorList)
        } catch {
             print("ERROR fetchSensors AddViewModel")
        }
    }

    func setAddItemList(stations: [Station], sensors: [Sensor]) {
        var addItems = [AddItem]()
        var sensorItems = [SensorItem]()
        let falseValue = RealmOptional<Bool>(false)
        
        let stationItem = stations.map { station in
            AddItem(
                id: station.id,
                stationId: station.id,
                cityName: station.city?.name ?? "",
                addressStreet: station.addressStreet!,
                added: falseValue,
                sensor: [])
        }
        addItems.append(contentsOf: stationItem)
        
        sensors.forEach { sensor in
            guard let index = stations.firstIndex(where: { $0.id == sensor.stationId}) else {
                print("Failed to find a station for sensor \(sensor.id)")
                return
            }
            let sensorItem = SensorItem(
                id: sensor.id,
                stationId: sensor.stationId,
                param: ParamItem(
                    paramName: sensor.param?.paramName ?? "",
                    paramFormula: sensor.param?.paramFormula ?? "",
                    paramCode: sensor.param?.paramCode ?? "",
                    idParam: sensor.param?.idParam ?? 0))
            
            sensorItems.append(sensorItem)
            addItems[index].sensors.append(sensorItem)
        }
        self.addItems.onNext(addItems)
    }
    
    func addStationItem(addItem: AddItem) {
        let trueValue = RealmOptional<Bool>(true)
        let sensors = Array(addItem.sensors)
        let item = AddItem(id: addItem.id,
                           stationId: addItem.stationId,
                           cityName: addItem.cityName,
                           addressStreet: addItem.addressStreet,
                           added: trueValue,
                           sensor: sensors)
        
        do {
            try
                self.persistenceService.addAddItem(addItem: item)
        }
        catch {
            print("Error AddViewModel: in saveStationItem saving error")
        }
        
        
    }
    
}

        
