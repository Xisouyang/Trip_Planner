//
//  WayPointVC.swift
//  Trip Planner
//
//  Created by Stephen Ouyang on 5/7/19.
//  Copyright © 2019 Stephen Ouyang. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces

class WaypointVC: UIViewController {
    
    var plannedTrip: String?
    var placesList: [Waypoint] = []
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    // creates view to hold search bar so we can actually touch the search bar
    let searchBarSubview = UIView(frame: .zero)
    let waypointTableView = UITableView(frame: .zero)
    let mapView = MKMapView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setNav()
        populateWaypointList()
    }
    
    override func loadView() {
        super.loadView()
        initSearchBar()
        setTableView()
        setMapView()
    }
    
    func setMapView() {
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = self
        view.addSubview(mapView)
        mapViewConstraints()
    }
    
    func addPinToMap(mapView: MKMapView, waypoint: Waypoint) {
        
        let lat = waypoint.latitude
        let long = waypoint.longitude
        let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = waypoint.address
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }
    
    func setTableView() {
        waypointTableView.register(WaypointCell.self, forCellReuseIdentifier: WaypointCell.identifier)
        waypointTableView.delegate = self
        waypointTableView.dataSource = self
        view.addSubview(waypointTableView)
        tableViewConstraints()
    }
    
    func setNav() {
        navigationItem.title = plannedTrip
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savedTapped))
        navigationController?.navigationBar.backgroundColor = .lightGray
    }
    
    func populateWaypointList() {
        guard let unwrappedTrip = plannedTrip else {
            print("no trip name")
            return
        }
        let trip = CoreDataManager.sharedManager.fetchTrip(tripName: unwrappedTrip) as! Trip
        let waypoints = trip.waypoints
        
        guard let unwrappedWaypoints = waypoints else {
            print("invalid waypoint list")
            return
        }
        
        for item in unwrappedWaypoints {
            let waypoint = item as! Waypoint
            placesList.append(waypoint)
        }
    }
    
    // creates search bar and put at top of view
    func initSearchBar() {
        
        // creates interface
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        // creates search bar
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        view.addSubview(searchBarSubview)
        searchBarViewConstraints()

        searchBarSubview.addSubview((searchController?.searchBar)!)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
    }
    
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc func savedTapped() {
        print("save tapped")
        CoreDataManager.sharedManager.saveContext()
        let newVC = PlannedTripVC()
        navigationController?.initRootViewController(vc: newVC)
    }
}

// Handle the user's selection.
extension WaypointVC: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.

        var waypointDict: [String: Any] = [:]
        
        guard let unwrappedTripName = plannedTrip else {
            print("no trip name")
            return
        }
        guard let unwrappedWaypointName = place.name else {
            print("no waypoint name")
            return
        }
         let trip = CoreDataManager.sharedManager.fetchTrip(tripName: unwrappedTripName)
        let lat = place.coordinate.latitude as Double
        let long = place.coordinate.longitude as Double
        
        waypointDict["name"] = unwrappedWaypointName
        waypointDict["address"] = place.formattedAddress
        waypointDict["longitude"] = long
        waypointDict["latitude"] = lat
        
        let waypoint = CoreDataManager.sharedManager.createWaypoint(waypointObj: waypointDict, trip: trip as! Trip) as! Waypoint
        placesList.append(waypoint)
        waypointTableView.reloadData()
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

// when users interact with table view
extension WaypointVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let waypoint = placesList[indexPath.row]
        addPinToMap(mapView: mapView, waypoint: waypoint)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let waypointObj = placesList[indexPath.row]
            placesList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            CoreDataManager.sharedManager.removeItem(objectID: waypointObj.objectID)
        }
    }
}

// how data represented with table view
extension WaypointVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WaypointCell.identifier, for: indexPath) as! WaypointCell
        cell.textLabel?.text = placesList[indexPath.row].name
        cell.waypoint = placesList[indexPath.row]
        return cell
    }
}

extension WaypointVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
}
