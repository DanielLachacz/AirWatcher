//
//  MapItem.swift
//  AirWatcher
//
//  Created by Daniel Łachacz on 10/04/2021.
//  Copyright © 2021 Daniel Łachacz. All rights reserved.
//

import Foundation.NSURL
import MapKit

class MapItem: NSObject, MKAnnotation {

    let id: Int?
    let name: String?
    let coordinate: CLLocationCoordinate2D
    let indexLevel: String
    
    init(id: Int, name: String, coordinate: CLLocationCoordinate2D, indexLevel: String) {
        self.id = id
        self.name = name
        self.coordinate = coordinate
        self.indexLevel = indexLevel
        
        super.init()
    }
}
