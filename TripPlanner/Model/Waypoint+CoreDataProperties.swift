//
//  Waypoint+CoreDataProperties.swift
//  Trip Planner
//
//  Created by Stephen Ouyang on 5/14/19.
//  Copyright © 2019 Stephen Ouyang. All rights reserved.
//
//

import Foundation
import CoreData


extension Waypoint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Waypoint> {
        return NSFetchRequest<Waypoint>(entityName: "Waypoint")
    }

    @NSManaged public var name: String?
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var trip: Trip?

}
