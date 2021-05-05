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
    //var mockPersistenceService: MockPersistenceService!
    
    override func setUp() {
       // mockPersistenceService = MockPersistenceService()
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.viewModel = FavoriteViewModel()
        //viewModel = .init()
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
        let addItemArray = [AddItem(id: 1, stationId: 1, cityName: "1", addressStreet: "1", added: RealmOptional<Bool>(false), sensor: [SensorItem(id: 1, stationId: 1, param: ParamItem(paramName: "1", paramFormula: "1", paramCode: "1", idParam: 1))]), AddItem(id: 2, stationId: 2, cityName: "2", addressStreet: "2", added: RealmOptional<Bool>(false), sensor: [SensorItem(id: 2, stationId: 2, param: ParamItem(paramName: "2", paramFormula: "2", paramCode: "2", idParam: 2))])]
        
        let airDataArray = [AirData](arrayLiteral: AirData(id: 1, stationId: 1, key: "Key1", values: [Value(date: "1", value: RealmOptional<Double>(1.0))]), AirData(id: 2, stationId: 2, key: "Key2", values: [Value(date: "2", value: RealmOptional<Double>(2.0))]))
        
        try! service.addAddItems(addItems: addItemArray)
        try! service.addData(data: airDataArray)
        
        let items = try! service.fetchAddItems()
        let datas = try! service.fetchData()
        
        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(datas.count, 2)
    }
    
    func test_fetchSavedAddItems_AndData_WithError() {
        
        
    }
}
