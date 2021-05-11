//
//  AddItem.swift
//  AirWatcher
//
//  Created by Daniel Łachacz on 01/12/2020.
//  Copyright © 2020 Daniel Łachacz. All rights reserved.
//

import Foundation.NSURL
import RealmSwift

class AddItem: Object, Identifiable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var stationId: Int = 0
    @objc dynamic var cityName: String = ""
    @objc dynamic var addressStreet: String = ""
    var added = RealmOptional<Bool>()
    let sensors = List<SensorItem>()
    
    convenience init(id: Int, stationId: Int, cityName: String, addressStreet: String, added: RealmOptional<Bool>, sensor: [SensorItem]) {
        self.init()
        self.id = id
        self.stationId = stationId
        self.cityName = cityName
        self.addressStreet = addressStreet
        self.added = added
        self.sensors.append(objectsIn: sensor)
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class SensorItem: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var stationId: Int = 0
    @objc dynamic var param: ParamItem?
    @objc dynamic var data: DataItem?
    
    convenience init(id: Int, stationId: Int, param: ParamItem) {
        self.init()
        self.id = id
        self.stationId = stationId
        self.param = param
    }
    
}

class ParamItem: Object {
    @objc dynamic var paramName: String = ""
    @objc dynamic var paramFormula: String = ""
    @objc dynamic var paramCode: String = ""
    @objc dynamic var idParam: Int = 0
    
    convenience init(paramName: String, paramFormula: String, paramCode: String, idParam: Int) {
        self.init()
        self.paramName = paramName
        self.paramFormula = paramFormula
        self.paramCode = paramCode
        self.idParam = idParam
    }
    
}

class DataItem: Object {
    @objc dynamic var id: Int = 0
    var values = List<ValueItem>()
    
    convenience init(id: Int, values: [ValueItem]) {
        self.init()
        self.id = id
        self.values.append(objectsIn: values)
    }
    
    override class func primaryKey() -> String? {
           return "id"
       }
}

class ValueItem: Object {
    
    @objc dynamic var date: String? = ""
    var value = RealmOptional<Double>()
    
    convenience init(date: String, value: RealmOptional<Double>) {
        self.init()
        self.date = date
        self.value = value
    }
}
