//
//  Station.swift
//  AirWatcher
//
//  Created by Daniel Łachacz on 15/11/2020.
//  Copyright © 2020 Daniel Łachacz. All rights reserved.
//

import Foundation.NSURL
import RealmSwift

class Station: Object, Identifiable, Decodable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var stationName: String = ""
    @objc dynamic var gegrLat: String = ""
    @objc dynamic var gegrLon: String = ""
    @objc dynamic var city: City?
    @objc dynamic var addressStreet: String? = "" 
    
    convenience init(id: Int, stationName: String, gegrLat: String, gegrLon: String, city: City, addressStreet: String) {
        self.init()
        self.id = id
        self.stationName = stationName
        self.gegrLat = gegrLat
        self.gegrLon = gegrLon
        self.city = city
        self.addressStreet = addressStreet
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

class City: Object, Decodable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var commune: Commune? 
    
}

class Commune: Object, Decodable {
    @objc dynamic var communeName: String = ""
    @objc dynamic var districtName: String = ""
    @objc dynamic var provinceName: String = ""
    
}
