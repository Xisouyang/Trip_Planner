//
//  WayPointVC.swift
//  Trip Planner
//
//  Created by Stephen Ouyang on 5/7/19.
//  Copyright © 2019 Stephen Ouyang. All rights reserved.
//

// 1. Set up navbar - UI done
// 2. Set up search bar - done
// 3. Set up tableview - done
// 4. Set up mapview - done

// add name of the place to table view - done
// current api already gives back coordinates
// need to create a custom cell to pass coordinates to
// then create region, set the span
// create annotation and give coordinates to annotation, add to mapview


import UIKit
import MapKit
import GooglePlaces

class WaypointVC: UIViewController {
        
    var waypointLabel: UILabel = {
       let label = UILabel()
       label.text = "Add Waypoint"
       return label
    }()
    
    var plannedTrip: String?
    var placesList: [Waypoint] = [] {
        didSet {
            waypointTableView.reloadData()
        }
    }
    
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
        annotation.title = waypoint.name
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
        navigationItem.title = waypointLabel.text
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
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
    
    @objc func cancelTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc func savedTapped() {
        print("save tapped")
        CoreDataManager.sharedManager.saveContext()
    }
}

// Handle the user's selection.
extension WaypointVC: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.

        // want to append string to array when I click item
        // would need to create a waypoint because the array is of type waypoint
        // but waypoint now needs the trip its associated with as a parameter
        //can't access the trip here
        
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
        let waypoint = CoreDataManager.sharedManager.createWaypoint(name: unwrappedWaypointName, latitude: lat, longitude: long, trip: trip as! Trip) as! Waypoint
        placesList.append(waypoint)
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
