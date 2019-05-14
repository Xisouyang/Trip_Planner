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
    
    func addWaypoints(mapView: MKMapView, cell: WaypointCell) {
        
        guard let location = cell.waypoint?.coordinates else {
            return
        }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = cell.waypoint?.name
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
    }
}

// Handle the user's selection.
extension WaypointVC: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(String(describing: place.name))")
        print("Place coordinates: \(String(describing: place.coordinate))")
        if let unwrappedPlaceName = place.name {
            let waypoint = Waypoint(coordinates: place.coordinate, name: unwrappedPlaceName)
            placesList.append(waypoint)
        }
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
        let cell = tableView.cellForRow(at: indexPath) as! WaypointCell
        addWaypoints(mapView: mapView, cell: cell)
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
