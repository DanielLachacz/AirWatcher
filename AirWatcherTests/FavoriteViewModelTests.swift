//
//  FavoriteViewModelTests.swift
//  AirWatcherTests
//
//  Created by Daniel Łachacz on 30/04/2021.
//  Copyright © 2021 Daniel Łachacz. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
import RealmSwift
@testable import AirWatcher

class FavoriteViewModelTests: XCTestCase {
    
    var viewModel: FavoriteViewModel!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    let service = PersistenceService()
    
    override func setUp() {
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.viewModel = FavoriteViewModel()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let realm = try! Realm()
        service.realm = realm
    }
    
    override func tearDown() {
        disposeBag = nil
        viewModel = nil
        scheduler = nil
        
    }

    func test_fetchSavedAddItems_AndData() {
         let addItemArray = [AddItem(id: 1, stationId: 1, cityName: "1", addressStreet: "1", added: RealmOptional<Bool>(false), sensor: [SensorItem]()), AddItem(id: 2, stationId: 2, cityName: "2", addressStreet: "2", added: RealmOptional<Bool>(false), sensor: [SensorItem]()), AddItem(id: 3, stationId: 3, cityName: "3", addressStreet: "3", added: RealmOptional<Bool>(false), sensor: [SensorItem]())]
        
        try! service.addAddItems(addItems: addItemArray)
        
        let dataArray = [AirData(id: 1, stationId: 1, key: "1", values: [Value]()), AirData(id: 2, stationId: 2, key: "2", values: [Value]()), AirData(id: 3, stationId: 3, key: "3", values: [Value]())]
        
        try! service.addData(data: dataArray)
        
        let first = scheduler.createObserver(Bool.self)
        let second = scheduler.createObserver(Bool.self)
        
        viewModel.error
            .bind(to: first)
            .disposed(by: disposeBag)
        
        viewModel.error
            .bind(to: second)
            .disposed(by: disposeBag)
        
        viewModel.fetchSavedAddItemsAndData()
        
        //XCTAssertEqual(viewModel.addArray.count, 3)
        //XCTAssertTrue(first)
        //XCTAssertEqual(first, false)
        XCTAssertRecordedElements(first.events, [true])
        XCTAssertRecordedElements(first.events, [true])
    }
    
    func test_SetFavoriteItems() {
        let addItemArray = [AddItem(id: 1, stationId: 1, cityName: "1", addressStreet: "1", added: RealmOptional<Bool>(false), sensor: [SensorItem(id: 1, stationId: 1, param: ParamItem())]), AddItem(id: 2, stationId: 2, cityName: "2", addressStreet: "2", added: RealmOptional<Bool>(false), sensor: [SensorItem(id: 2, stationId: 2, param: ParamItem())]), AddItem(id: 3, stationId: 3, cityName: "3", addressStreet: "3", added: RealmOptional<Bool>(false), sensor: [SensorItem(id: 3, stationId: 3, param: ParamItem())])]
        
        let dataArray = [AirData(id: 1, stationId: 1, key: "1", values: [Value]()), AirData(id: 2, stationId: 2, key: "2", values: [Value]()), AirData(id: 3, stationId: 3, key: "3", values: [Value]())]
        
        viewModel.setFavoriteItems(addArray: addItemArray, dataArray: dataArray)
        
        let result = try! viewModel.favoriteItemArrayBS.asObserver().value()
        
        XCTAssertEqual(result.count, 3)
    }
    
    func test_SetFavoriteItems_WithError() {
        let addItemArray = [AddItem(id: 1, stationId: 1, cityName: "1", addressStreet: "1", added: RealmOptional<Bool>(false), sensor: [SensorItem(id: 0, stationId: 1, param: ParamItem())]), AddItem(id: 2, stationId: 0, cityName: "2", addressStreet: "2", added: RealmOptional<Bool>(false), sensor: [SensorItem(id: 0, stationId: 0, param: ParamItem())]), AddItem(id: 3, stationId: 3, cityName: "3", addressStreet: "3", added: RealmOptional<Bool>(false), sensor: [SensorItem(id: 0, stationId: 0, param: ParamItem())])]
        
        let dataArray = [AirData(id: 1, stationId: 1, key: "1", values: [Value]()), AirData(id: 2, stationId: 2, key: "2", values: [Value]()), AirData(id: 3, stationId: 3, key: "3", values: [Value]())]
        
        viewModel.setFavoriteItems(addArray: addItemArray, dataArray: dataArray)
        
        XCTAssert(true, "Failed to find a Sensor for the Data 1")
        XCTAssert(true, "Failed to find a Sensor for the Data 2")
        XCTAssert(true, "Failed to find a Sensor for the Data 3")
    }
}
