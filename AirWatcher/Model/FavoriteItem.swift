//
//  FavoriteItem.swift
//  AirWatcher
//
//  Created by Daniel Łachacz on 14/01/2021.
//  Copyright © 2021 Daniel Łachacz. All rights reserved.
//

import Foundation.NSURL
import RealmSwift

class FavoriteItem: Identifiable {
    
    var id: Int = 0
    var cityName: String = ""
    var addressStreet: String = ""
    var sensors = [FavoriteSensor]()
    
    convenience init(id: Int, cityName: String, addressStreet: String, sensors: [FavoriteSensor]) {
        self.init()
        self.id = id
        self.cityName = cityName
        self.addressStreet = addressStreet
        self.sensors = sensors
    }
    
}

class FavoriteSensor {
    var id: Int = 0
    var stationId: Int = 0
    var data: FavoriteData?
    
    convenience init(id: Int, stationId: Int, data: FavoriteData) {
        self.init()
        self.id = id
        self.stationId = stationId
        self.data = data
    }
    
}

class FavoriteData {
    var id: Int = 0
    var key: String = ""
    var values = [FavoriteValue]()
    
    convenience init(id: Int, key: String, values: [FavoriteValue]) {
        self.init()
        self.id = id
        self.key = key
        self.values =  values
    }
    
}

class FavoriteValue {
    
    var date: String? = ""
    var value: Double = 0
    
    convenience init(date: String, value: Double) {
        self.init()
        self.date = date
        self.value = value
    }
}
