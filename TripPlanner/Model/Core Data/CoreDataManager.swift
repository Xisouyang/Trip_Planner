//
//  CoreDataManager.swift
//  Trip Planner
//
//  Created by Stephen Ouyang on 5/14/19.
//  Copyright © 2019 Stephen Ouyang. All rights reserved.


// create 2 entities
//  Trip Entity
//  Waypoint Entity

// Trip Entity Properties
    // name
    // Trip Entity Relationship
        // waypoints

// Waypoint Entity Properties
    // name
    // latitude
    // longitude
    // Way Entity Relationship
        // Trip

// create 4 functions:
    // create
    // save
    // delete
    // fetch


import Foundation
import CoreData

class CoreDataManager {
    
    //This Core Data manager works as a Singleton. This means you will use the same instance throughout the project. Call its sharedManager to have access to its methods.
    static let sharedManager = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Trip_Planner")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
       return persistentContainer.viewContext
    }()
    
    func saveContext () {
    
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createTrip(tripName: String) -> NSManagedObject? {
        
        let tripEntity = NSEntityDescription.entity(forEntityName: "Trip", in: context)
        guard let unwrappedEntity = tripEntity else {
            print("trip entity failed to unwrap")
            return nil
        }
        let trip = NSManagedObject(entity: unwrappedEntity, insertInto: context)
        trip.setValue(tripName, forKey: "name")
        saveContext()
        return trip
    }
    
    func fetchAllTrips() -> [NSManagedObject]? {
        
        var allTrips: [Trip] = []
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Trip")
        
        do {
            allTrips = try context.fetch(fetchRequest) as! [Trip]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return allTrips
    }
    
    func fetchTrip(tripName: String) -> NSManagedObject? {
        
        var allTrips: [Trip] = []
        var trip: Trip?
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Trip")
        fetchRequest.predicate = NSPredicate(format: "name = %@", tripName)
        
        do {
            allTrips = try context.fetch(fetchRequest) as! [Trip]
            if allTrips.count > 0 {
                trip = allTrips.first
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return trip
    }
    
    func createWaypoint(waypointObj: [String: Any], trip: Trip) -> NSManagedObject? {
        let waypointEntity = NSEntityDescription.entity(forEntityName: "Waypoint", in: context)
        guard let unwrappedEntity = waypointEntity else {
            print("waypoint entity failed to unwrap")
            return nil
        }
        let waypoint = NSManagedObject(entity: unwrappedEntity, insertInto: context)
        waypoint.setValuesForKeys(waypointObj)
        trip.addToWaypoints(waypoint as! Waypoint)
        return waypoint
    }
    
    func removeItem( objectID: NSManagedObjectID ) {
        let obj = context.object(with: objectID)
        context.delete(obj)
    }
}
