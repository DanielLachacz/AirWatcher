//
//  Data.swift
//  AirWatcher
//
//  Created by Daniel Łachacz on 25/11/2020.
//  Copyright © 2020 Daniel Łachacz. All rights reserved.
//

import Foundation.NSURL
import RealmSwift
import Realm

class Data: Object, Decodable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var stationId: Int = 0 //indifaction during the making of the new FavoriteItem
    @objc dynamic var key: String = ""
    var values = List<Value>()
    
    convenience init(id: Int, stationId: Int, key: String, values: [Value]) {
        self.init()
        self.id = id
        self.stationId = stationId
        self.key = key
        self.values.append(objectsIn: values)
    }
    
    private enum CodingKeys: String, CodingKey {
        case key = "key"
        case values = "values"
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class Value: Object, Decodable {
    
    @objc dynamic var date: String? = ""
    var value = RealmOptional<Double>()
    
    convenience init(date: String, value: RealmOptional<Double>) {
        self.init()
        self.date = date
        self.value = value
    }
}
