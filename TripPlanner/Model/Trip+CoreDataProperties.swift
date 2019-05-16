//
//  Trip+CoreDataProperties.swift
//  TripPlanner
//
//  Created by Stephen Ouyang on 5/15/19.
//  Copyright © 2019 Stephen Ouyang. All rights reserved.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var name: String?
    @NSManaged public var waypoints: NSOrderedSet?

}

// MARK: Generated accessors for waypoints
extension Trip {

    @objc(insertObject:inWaypointsAtIndex:)
    @NSManaged public func insertIntoWaypoints(_ value: Waypoint, at idx: Int)

    @objc(removeObjectFromWaypointsAtIndex:)
    @NSManaged public func removeFromWaypoints(at idx: Int)

    @objc(insertWaypoints:atIndexes:)
    @NSManaged public func insertIntoWaypoints(_ values: [Waypoint], at indexes: NSIndexSet)

    @objc(removeWaypointsAtIndexes:)
    @NSManaged public func removeFromWaypoints(at indexes: NSIndexSet)

    @objc(replaceObjectInWaypointsAtIndex:withObject:)
    @NSManaged public func replaceWaypoints(at idx: Int, with value: Waypoint)

    @objc(replaceWaypointsAtIndexes:withWaypoints:)
    @NSManaged public func replaceWaypoints(at indexes: NSIndexSet, with values: [Waypoint])

    @objc(addWaypointsObject:)
    @NSManaged public func addToWaypoints(_ value: Waypoint)

    @objc(removeWaypointsObject:)
    @NSManaged public func removeFromWaypoints(_ value: Waypoint)

    @objc(addWaypoints:)
    @NSManaged public func addToWaypoints(_ values: NSOrderedSet)

    @objc(removeWaypoints:)
    @NSManaged public func removeFromWaypoints(_ values: NSOrderedSet)

}
