//
//  AirQualityIndex.swift
//  AirWatcher
//
//  Created by Daniel Łachacz on 11/04/2021.
//  Copyright © 2021 Daniel Łachacz. All rights reserved.
//

import Foundation.NSURL
import RealmSwift

class AirQualityIndex: Object, Decodable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var stCalcDate: String? = ""
    @objc dynamic var stIndexLevel: StIndexLevel?
    
    convenience init(id: Int, stCalcDate: String, stIndexLevel: StIndexLevel) {
        self.init()
            self.id = id
            self.stCalcDate = stCalcDate
            self.stIndexLevel = stIndexLevel
        }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class StIndexLevel: Object, Decodable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var indexLevelName: String? = ""

}


