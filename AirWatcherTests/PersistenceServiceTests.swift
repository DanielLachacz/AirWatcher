//
//  PersistenceServiceTests.swift
//  AirWatcherTests
//
//  Created by Daniel Łachacz on 04/05/2021.
//  Copyright © 2021 Daniel Łachacz. All rights reserved.
//

import XCTest
import RealmSwift
@testable import AirWatcher

class PersistenceServiceTests: XCTestCase {
    
    let service = PersistenceService()
    
    override func setUp() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let realm = try! Realm()
        service.realm = realm
    }
    
    func test_AddStations() {
        let stationArray = [Station(id: 1, stationName: "1", gegrLat: "1", gegrLon: "1", city: City(), addressStreet: "1"), Station(id: 2, stationName: "2", gegrLat: "2", gegrLon: "2", city: City(), addressStreet: "2")]
        
        try! service.addStations(stations: stationArray)
        let stations = service.realm?.objects(Station.self)
        
        XCTAssertEqual(stations?.count, 2)
    }
    
    func test_AddStations_WithError() {
        do {
            let stationArray = [Station(id: 1, stationName: "1", gegrLat: "1", gegrLon: "1", city: City(), addressStreet: "1"), Station(id: 2, stationName: "2", gegrLat: "2", gegrLon: "2", city: City(), addressStreet: "2")]
            
            service.realm = nil
            try service.addStations(stations: stationArray)
            let stations = service.realm?.objects(Station.self)
            
            XCTAssertEqual(stations?.count, 2)
        }
        catch RuntimeError.NoRealmSet
        {
            XCTAssert(false, "PERSISTENCE SERVICE: No Realm Database addStations")
        }
        catch
        {
            XCTAssert(false, "\(error.localizedDescription)")
        }
    }
    
    func test_AddSensors() {
        let sensorArray = [Sensor(id: 1, stationId: 1, param: Param()), Sensor(id: 2, stationId: 2, param: Param())]
        
        try! service.addSensors(sensors: sensorArray)
        let sensors = service.realm?.objects(Sensor.self)
        
        XCTAssertEqual(sensors?.count, 2)
    }
    
    func test_AddSensors_WithError() {
        do {
            let sensorArray = [Sensor(id: 1, stationId: 1, param: Param()), Sensor(id: 2, stationId: 2, param: Param())]
            
            service.realm = nil
            try service.addSensors(sensors: sensorArray)
            let sensors = service.realm?.objects(Sensor.self)
            
            XCTAssertEqual(sensors?.count, 2)
        }
        catch RuntimeError.NoRealmSet
        {
            XCTAssert(false, "PERSISTENCE SERVICE: No Realm Database addSensors")
        }
        catch
        {
            XCTAssert(false, "\(error.localizedDescription)")
        }
    }
    
    func test_AddData() {
        let dataArray = [AirData(id: 1, stationId: 1, key: "1", values: [Value]()), AirData(id: 2, stationId: 2, key: "2", values: [Value]())]
        
        try! service.addData(data: dataArray)
        let data = service.realm?.objects(AirData.self)
        
        XCTAssertEqual(data?.count, 2)
    }
    
    func test_AddData_WithError() {
        do {
            let dataArray = [AirData(id: 1, stationId: 1, key: "1", values: [Value]()), AirData(id: 2, stationId: 2, key: "2", values: [Value]())]
            
            service.realm = nil
            try service.addData(data: dataArray)
            let data = service.realm?.objects(AirData.self)
            
            XCTAssertEqual(data?.count, 2)
        }
        catch RuntimeError.NoRealmSet {
           XCTAssert(false, "PERSISTENCE SERVICE: No Realm Database addData")
        }
        catch let error as NSError
        {
           XCTAssert(false, "\(error.localizedDescription)")
        }
    }
    
    func test_AddAirQualityIndex() {
        let airQualityIndexArray = [AirQualityIndex(id: 1, stCalcDate: "1", stIndexLevel: StIndexLevel()),
        AirQualityIndex(id: 2, stCalcDate: "2", stIndexLevel: StIndexLevel())]
        
        try! service.addAirQualityIndex(air: airQualityIndexArray)
        let air = service.realm?.objects(AirQualityIndex.self)
        
        XCTAssertEqual(air?.count, 2)
    }
    
    func test_AddAirQualityIndex_WithError() {
        do {
            let airQualityIndexArray = [AirQualityIndex(id: 1, stCalcDate: "1", stIndexLevel: StIndexLevel()),
            AirQualityIndex(id: 2, stCalcDate: "2", stIndexLevel: StIndexLevel())]
            
            service.realm = nil
            try service.addAirQualityIndex(air: airQualityIndexArray)
            let air = service.realm?.objects(AirQualityIndex.self)
            
            XCTAssertEqual(air?.count, 2)
        }
        catch RuntimeError.NoRealmSet {
           XCTAssert(false, "PERSISTENCE SERVICE: No Realm Database addAirQualityIndex")
        }
        catch let error as NSError
        {
           XCTAssert(false, "\(error.localizedDescription)")
        }
    }
    
    func test_AddAddItem() {
        let addItem = AddItem(id: 1, stationId: 1, cityName: "1", addressStreet: "1", added: RealmOptional<Bool>(false), sensor: [SensorItem]())
        
        try! service.addAddItem(addItem: addItem)
        let addItems = service.realm?.objects(AddItem.self)
        
        XCTAssertEqual(addItems?.count, 1)
    }
    
    func test_AddItem_WithError() {
        do {
            let addItem = AddItem(id: 1, stationId: 1, cityName: "1", addressStreet: "1", added: RealmOptional<Bool>(false), sensor: [SensorItem]())
            
            service.realm = nil
            try service.addAddItem(addItem: addItem)
            let addItems = service.realm?.objects(AddItem.self)
            
            XCTAssertEqual(addItems?.count, 1)
        }
        catch RuntimeError.NoRealmSet {
           XCTAssert(false, "PERSISTENCE SERVICE: No Realm Database addAddItem")
        }
        catch let error as NSError
        {
           XCTAssert(false, "\(error.localizedDescription)")
        }
    }
    
    func test_AddAddItems() {
        let addItemArray = [AddItem(id: 1, stationId: 1, cityName: "1", addressStreet: "1", added: RealmOptional<Bool>(false), sensor: [SensorItem]()), AddItem(id: 2, stationId: 2, cityName: "2", addressStreet: "2", added: RealmOptional<Bool>(false), sensor: [SensorItem]())]
        
        try! service.addAddItems(addItems: addItemArray)
        let addItems = service.realm?.objects(AddItem.self)
        
        XCTAssertEqual(addItems?.count, 2)
    }
    
    func test_AddItems_WithError() {
        do {
            let addItemArray = [AddItem(id: 1, stationId: 1, cityName: "1", addressStreet: "1", added: RealmOptional<Bool>(false), sensor: [SensorItem]()), AddItem(id: 2, stationId: 2, cityName: "2", addressStreet: "2", added: RealmOptional<Bool>(false), sensor: [SensorItem]())]
            
            service.realm = nil
            try service.addAddItems(addItems: addItemArray)
            let addItems = service.realm?.objects(AddItem.self)
            
            XCTAssertEqual(addItems?.count, 1)
        }
        catch RuntimeError.NoRealmSet {
           XCTAssert(false, "PERSISTENCE SERVICE: No Realm Database addAddItems")
        }
        catch let error as NSError
        {
           XCTAssert(false, "\(error.localizedDescription)")
        }
    }
    
    func test_deleteAddItem() {
        do {
            let addItem = AddItem(id: 1, stationId: 1, cityName: "1", addressStreet: "1", added: RealmOptional<Bool>(false), sensor: [SensorItem]())
            
            try service.addAddItem(addItem: addItem)
            let addItems = service.realm?.objects(AddItem.self)
            XCTAssertEqual(addItems?.count, 1)
            
            try service.deleteAddItem(addItem: addItem)
            let addItemsAfterDelete = service.realm?.objects(AddItem.self)
            XCTAssertEqual(addItemsAfterDelete?.count, 0)
            
        }
        catch RuntimeError.NoRealmSet
        {
            XCTAssert(false)
        }
        catch let error as NSError
        {
           XCTAssert(false, "\(error.localizedDescription)")
        }
    }
    
    func test_fetchAddItems() {
        let addItem1 = AddItem(id: 1, stationId: 1, cityName: "1", addressStreet: "1", added: RealmOptional<Bool>(false), sensor: [SensorItem]())
        let addItem2 = AddItem(id: 2, stationId: 2, cityName: "2", addressStreet: "2", added: RealmOptional<Bool>(false), sensor: [SensorItem]())
        
        try! service.addAddItem(addItem: addItem1)
        try! service.addAddItem(addItem: addItem2)
        
        let addItems = try! service.fetchAddItems()
        XCTAssertEqual(addItems.count, 2)
    }
    
    func test_fetchStations() {
        let stationArray = [Station(id: 1, stationName: "1", gegrLat: "1", gegrLon: "1", city: City(), addressStreet: "1"), Station(id: 2, stationName: "2", gegrLat: "2", gegrLon: "2", city: City(), addressStreet: "2")]
        
        try! service.addStations(stations: stationArray)
        
        let stations = try! service.fetchStations()
        XCTAssertEqual(stations.count, 2)
    }
    
    func test_fetchSensors() {
        let sensorArray = [Sensor(id: 1, stationId: 1, param: Param()), Sensor(id: 2, stationId: 2, param: Param())]
        
        try! service.addSensors(sensors: sensorArray)
        
        let sensors = try! service.fetchSensors()
        XCTAssertEqual(sensors.count, 2)
    }
    
    func test_FetchData() {
        let dataArray = [AirData(id: 1, stationId: 1, key: "1", values: [Value]()), AirData(id: 2, stationId: 2, key: "2", values: [Value]())]
        
        try! service.addData(data: dataArray)
        
        let data = try! service.fetchData()
        XCTAssertEqual(data.count, 2)
    }
    
    func test_fetchAirQualityIndex() {
        let airQualityIndexArray = [AirQualityIndex(id: 1, stCalcDate: "1", stIndexLevel: StIndexLevel()),
        AirQualityIndex(id: 2, stCalcDate: "2", stIndexLevel: StIndexLevel())]
        
        try! service.addAirQualityIndex(air: airQualityIndexArray)
        let air = try! service.fetchAirQualityIndex()
        
        XCTAssertEqual(air.count, 2)
    }
}
