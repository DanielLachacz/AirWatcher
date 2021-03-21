//
//  Sensor.swift
//  AirWatcher
//
//  Created by Daniel Łachacz on 20/11/2020.
//  Copyright © 2020 Daniel Łachacz. All rights reserved.
//

import Foundation.NSURL
import RealmSwift

class Sensor: Object, Identifiable, Decodable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var stationId: Int = 0
    @objc dynamic var param: Param?
    
    convenience init(id: Int, stationId: Int, param: Param) {
        self.init()
        self.id = id
        self.stationId = stationId
        self.param = param
        
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class Param: Object, Decodable {
    
    @objc dynamic var paramName: String = ""
    @objc dynamic var paramFormula: String = ""
    @objc dynamic var paramCode: String = ""
    @objc dynamic var idParam: Int = 0
}
