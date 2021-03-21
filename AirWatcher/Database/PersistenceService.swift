//
//  PersitenceService.swift
//  AirWatcher
//
//  Created by Daniel Łachacz on 15/11/2020.
//  Copyright © 2020 Daniel Łachacz. All rights reserved.
//

import RealmSwift
import RxSwift
import RxCocoa

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
    func deleteStationItem(stationItem: AddItem) throws
    func fetchAddItems() throws -> [AddItem]
   // func fetchFavoriteItems() throws -> [FavoriteItem]
    func addData(data: [Data]) throws
   // func addFavoriteItems(favoriteItems: [FavoriteItem]) throws
    func fetchData() throws -> [Data]
    func fetchDataItems() throws -> [DataItem]
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
    
    func addData(data: [Data]) throws {
               let objects = data.map { Data(value: $0)}
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
    
    func addAddItem(addItem: AddItem) throws {
        //print("addAddItem: \(addItem)")
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
    
//    func addFavoriteItems(favoriteItems: [FavoriteItem]) throws {
//                  let objects = favoriteItems.map { FavoriteItem(value: $0)}
//                  autoreleasepool {
//                  do {
//                   self.realm = try Realm()
//                   try self.realm!.write {
//                       self.realm!.add(objects, update: Realm.UpdatePolicy.modified)
//                      }
//                  }
//                  catch RuntimeError.NoRealmSet
//                  {
//                      print("PERSISTENCE SERVICE: No Realm Database addFavoriteItems")
//                  }
//                  catch let error as NSError
//                  {
//                      print(error.localizedDescription)
//                  }
//           }
//       }
    
    func deleteStationItem(stationItem: AddItem) throws {
        do {
            realm = try Realm()
            try realm!.write {
                realm?.delete(stationItem)
            }
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
    
    func fetchAddItems() throws -> [AddItem] {
        do {
            realm = try Realm()
            return realm!.objects(AddItem.self).toArray(ofType: AddItem.self)
        }
        catch {
            throw RuntimeError.NoRealmSet
        }
    }
    
//    func fetchFavoriteItems() throws -> [FavoriteItem] {
//        do {
//            realm = try Realm()
//            return realm!.objects(FavoriteItem.self).toArray(ofType: FavoriteItem.self)
//        }
//        catch {
//            throw RuntimeError.NoRealmSet
//        }
//    }
   
    func fetchData() throws -> [Data] {
        do {
            realm = try Realm()
            return realm!.objects(Data.self).toArray(ofType: Data.self)
        }
        catch {
            throw RuntimeError.NoRealmSet
    }
    }
    
    //I used such a solution because of the threads
//    func fetchData2() throws -> [Data] {
//        do {
//            realm = try Realm()
//            return realm!.objects(Data.self).toArray(ofType: Data.self)
//        }
//        catch {
//            throw RuntimeError.NoRealmSet
//    }
//    }
    
    func fetchDataItems() throws -> [DataItem] {
        do {
                   realm = try Realm()
                   return realm!.objects(DataItem.self).toArray(ofType: DataItem.self)
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
