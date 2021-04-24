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
    
    init(id: Int, name: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.coordinate = coordinate
        
        super.init()
    }
}
