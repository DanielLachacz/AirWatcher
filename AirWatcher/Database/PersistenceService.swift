//
//  PersitenceService.swift
//  AirWatcher
//
//  Created by Daniel Łachacz on 15/11/2020.
//  Copyright © 2020 Daniel Łachacz. All rights reserved.
//

import RealmSwift

enum RuntimeError: Error {
    
    case NoRealmSet
}

protocol PersistenceServiceProtocol {
    
    func addStations(stations: [Station]) throws
    func fetchStations() throws -> Results<Station>
    func addSensors(sensors: [Sensor]) throws
    func fetchSensors() throws -> Results<Sensor>
    func addAddItem(addItem: AddItem) throws
    func addAddItems(addItems: [AddItem]) throws
    func deleteAddItem(addItem: AddItem) throws
    func fetchAddItems() throws -> Results<AddItem>
    func addData(data: [AirData]) throws
    func fetchData() throws -> Results<AirData>
    func addAirQualityIndex(air: [AirQualityIndex]) throws
    func fetchAirQualityIndex() throws -> Results<AirQualityIndex>
}

final class PersistenceService: PersistenceServiceProtocol {
    
    var realm: Realm?
    
        
    func addStations(stations: [Station]) throws {
        let objects = stations.map { Station(value: $0)}
        autoreleasepool {
            do {
                realm = try Realm()
                try realm!.write {
                    realm!.add(objects, update: Realm.UpdatePolicy.modified)
                }
            }
            catch RuntimeError.NoRealmSet
            {
                print("PERSISTENCE SERVICE: No Realm Database addStations")
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
        }
    }
    
    func addSensors(sensors: [Sensor]) throws {
        let objects = sensors.map { Sensor(value: $0)}
        autoreleasepool {
            do {
                realm = try Realm()
                try realm!.write {
                    realm!.add(objects, update: Realm.UpdatePolicy.modified)
                }
            }
            catch RuntimeError.NoRealmSet
            {
                print("PERSISTENCE SERVICE: No Realm Database addSensors")
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
        }
    }
    
    func addData(data: [AirData]) throws {
        let objects = data.map { AirData(value: $0)}
        autoreleasepool {
            do {
                self.realm = try Realm()
                try self.realm!.write {
                    self.realm!.add(objects, update: Realm.UpdatePolicy.modified)
                }
            }
            catch RuntimeError.NoRealmSet
            {
                print("PERSISTENCE SERVICE: No Realm Database addData")
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
        }
    }
    
    func addAirQualityIndex(air: [AirQualityIndex]) throws {
        let objects = air.map { AirQualityIndex(value: $0)}
        autoreleasepool {
            do {
                self.realm = try Realm()
                try self.realm!.write {
                    self.realm!.add(objects, update: Realm.UpdatePolicy.modified)
                }
            }
            catch RuntimeError.NoRealmSet
            {
                print("PERSISTENCE SERVICE: No Realm Database addAirQualityIndex")
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
        }
    }
    
    func addAddItem(addItem: AddItem) throws {
        autoreleasepool {
        do {
            realm = try Realm()
            try realm!.write {
                realm!.add(addItem, update: Realm.UpdatePolicy.modified)
            }
        }
        catch RuntimeError.NoRealmSet
        {
            print("PERSISTENCE SERVICE: No Realm Database addAddItem")
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
        }
    }
    
    func addAddItems(addItems: [AddItem]) throws {
        let objects = addItems.map { AddItem(value: $0)}
        autoreleasepool {
            do {
                self.realm = try Realm()
                try self.realm!.write {
                    self.realm!.add(objects, update: Realm.UpdatePolicy.modified)
                }
            }
            catch RuntimeError.NoRealmSet
            {
                print("PERSISTENCE SERVICE: No Realm Database addAddItems")
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteAddItem(addItem: AddItem){
        let realm = try! Realm()
        try! realm.write {
            if let itemToDelete = realm.object(ofType: AddItem.self, forPrimaryKey: addItem.id) {
                realm.delete(itemToDelete)
            }
        }
    }
    
    func fetchAddItems() throws -> Results<AddItem> {
        do {
            let realm = try Realm()
            return realm.objects(AddItem.self)
        }
        catch {
            throw RuntimeError.NoRealmSet
        }
    }
        
    func fetchStations() throws -> Results<Station> {
            do {
                realm = try Realm()
                return realm!.objects(Station.self)
            }
            catch {
                throw RuntimeError.NoRealmSet
            }
        }
    
    func fetchSensors() throws -> Results<Sensor> {
        do {
            realm = try Realm()
            return realm!.objects(Sensor.self)
        }
        catch {
            throw RuntimeError.NoRealmSet
        }
      }
   
    func fetchData() throws -> Results<AirData> {
        do {
            realm = try Realm()
            return realm!.objects(AirData.self)
        }
        catch {
            throw RuntimeError.NoRealmSet
    }
    }
    
    func fetchAirQualityIndex() throws -> Results<AirQualityIndex> {
        do {
            let realm = try Realm()
            return realm.objects(AirQualityIndex.self)
        }
        catch {
            throw RuntimeError.NoRealmSet
        }
    }
    
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        let array = Array(self) as! [T]
        return array
    }
}

