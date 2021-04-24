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
    var addItems2 = PublishSubject<[AddItem]>()
    var stationList = [Station]()
    var sensorList = [Sensor]()
    let disposeBag = DisposeBag()
    var addList = [AddItem]()
    var addList2 = [AddItem]()
    
    init(persistenceService: PersistenceServiceProtocol =
    PersistenceService()) {
        self.persistenceService = persistenceService
    }
    
    func fetchSavedStations() {
        do {
            stationList += try persistenceService.fetchStations()
            self.stations.onNext(stationList)
        } catch {
            print("ERROR fetchSavedStations AddViewModel")
        }
        
        fetchSavedAddItems()
        fetchSavedSensors()
        if stationList.count > 0 && sensorList.count > 0 {
            setAddItemList(stations: stationList, sensors: sensorList)
        }
    }
    
    func fetchSavedAddItems() {
        do {
            addList2 += try persistenceService.fetchAddItems().toArray(ofType: AddItem.self)
        } catch {
            print("ERROR fetchSavedAddItems AddViewModel")
        }
    }
    
    func fetchSavedSensors() {
        do {
            sensorList += try persistenceService.fetchSensors()
            self.sensors.onNext(sensorList)
        } catch {
             print("ERROR fetchSavedSensors AddViewModel")
        }
    }

    func setAddItemList(stations: [Station], sensors: [Sensor]) {
        var addItems = [AddItem]()
        var sensorItems = [SensorItem]()
        let falseValue = RealmOptional<Bool>(false)
        let trueValue = RealmOptional<Bool>(true)
        
        let addItem = stations.map { station in
            AddItem(
                id: station.id,
                stationId: station.id,
                cityName: station.city?.name ?? "",
                addressStreet: station.addressStreet!,
                added: falseValue,
                sensor: [])
        }
        addItems.append(contentsOf: addItem)
        
        //DZIALA!!!
        addItem.forEach { item in
            guard let index = addList2.firstIndex(where: { $0.id == item.id})
                else {
                    print("Failed to find the SavedAddItem for the AddItem \(item.id)")
                    return
            }
            addItems[index + 1].added = trueValue
        }
        
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
        self.addList.append(contentsOf: addItems)
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
                fetchSavedStations()
        }
        catch {
            print("Error AddViewModel: in saveStationItem saving error")
        }
        
        
    }
    
}

        
