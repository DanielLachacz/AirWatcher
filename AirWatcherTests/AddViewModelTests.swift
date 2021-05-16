//
//  AddViewModelTests.swift
//  AirWatcherTests
//
//  Created by Daniel Łachacz on 12/05/2021.
//  Copyright © 2021 Daniel Łachacz. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
import RealmSwift
@testable import AirWatcher

class AddViewModelTests: XCTestCase {
    
    var viewModel: AddViewModel!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        self.viewModel = AddViewModel()
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        viewModel = nil
    }
    
    func test_SetAddItemList() {
        let scheduler = TestScheduler(initialClock: 0)
        let disposeBag = DisposeBag()
        
        let stations = [Station(id: 1, stationName: "1", gegrLat: "1", gegrLon: "1", city: City(), addressStreet: "1"),
        Station(id: 2, stationName: "2", gegrLat: "2", gegrLon: "2", city: City(), addressStreet: "2"),
        Station(id: 3, stationName: "3", gegrLat: "3", gegrLon: "3", city: City(), addressStreet: "3")]
        
        let sensors = [Sensor(id: 1, stationId: 1, param: Param()),
        Sensor(id: 2, stationId: 2, param: Param()),
        Sensor(id: 3, stationId: 3, param: Param())]
        
        let adds = [AddItem(id: 1, stationId: 1, cityName: "1", addressStreet: "1", added: RealmOptional<Bool>(false), sensor: [SensorItem()]),
            AddItem(id: 2, stationId: 2, cityName: "2", addressStreet: "2", added: RealmOptional<Bool>(false), sensor: [SensorItem()])]
        
        scheduler.scheduleAt(20) {
            self.viewModel.addList2 += adds
            self.viewModel.setAddItemList(stations: stations, sensors: sensors)
        }
        
        let result = scheduler.record(viewModel.addItems.asObservable(),
                                      disposeBag: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(result.events.compactMap{$0.value.element}.flatMap{$0}.count, 3)
    }
    
    func test_SetAddItemList_WithError() {
        let stations = [Station(id: 1, stationName: "1", gegrLat: "1", gegrLon: "1", city: City(), addressStreet: "1"),
        Station(id: 2, stationName: "2", gegrLat: "2", gegrLon: "2", city: City(), addressStreet: "2"),
        Station(id: 3, stationName: "3", gegrLat: "3", gegrLon: "3", city: City(), addressStreet: "3")]
        
        let sensors = [Sensor(id: 1, stationId: 1, param: Param()),
        Sensor(id: 2, stationId: 2, param: Param()),
        Sensor(id: 3, stationId: 3, param: Param())]
        
        let adds = [AddItem(id: 4, stationId: 4, cityName: "4", addressStreet: "4", added: RealmOptional<Bool>(false), sensor: [SensorItem()]),
            AddItem(id: 5, stationId: 5, cityName: "5", addressStreet: "2", added: RealmOptional<Bool>(false), sensor: [SensorItem()])]
        
        self.viewModel.addList2 += adds
        self.viewModel.setAddItemList(stations: stations, sensors: sensors)
        
        XCTAssert(true, "Failed to find the SavedAddItem for the AddItem 1")
        XCTAssert(true, "Failed to find the SavedAddItem for the AddItem 2")
        XCTAssert(true, "Failed to find the SavedAddItem for the AddItem 3")
    }
}

extension TestScheduler {
    
    func record<O: ObservableConvertibleType>(
        _ source: O,
        disposeBag: DisposeBag
    ) -> TestableObserver<O.Element> {
        let observer = self.createObserver(O.Element.self)
        source
            .asObservable()
            .bind(to: observer)
            .disposed(by: disposeBag)
        return observer
    }

}
