//
//  Waypoint.swift
//  Trip Planner
//
//  Created by Stephen Ouyang on 5/14/19.
//  Copyright © 2019 Stephen Ouyang. All rights reserved.
//

import Foundation
import MapKit

struct Waypoint {
    
    var coordinates: CLLocationCoordinate2D?
    var name: String?
    
    init(coordinates: CLLocationCoordinate2D, name: String) {
        self.coordinates = coordinates
        self.name = name
    }
}
