//
//  WayPointVC.swift
//  Trip Planner
//
//  Created by Stephen Ouyang on 5/7/19.
//  Copyright © 2019 Stephen Ouyang. All rights reserved.
//

//    // 1. Set up navbar - UI done
//    // 2. Set up search bar - done
//    // 3. Set up tableview
//    // 4. Set up mapview


import UIKit
import MapKit
import GooglePlaces

class WaypointVC: UIViewController {
    
    let identifier = "cell"
    
    var waypointLabel: UILabel = {
       let label = UILabel()
       label.text = "Add Waypoint"
       return label
    }()
    
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
        view.addSubview(mapView)
        mapViewConstraints()
    }
    
    func setTableView() {
        waypointTableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
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
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
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

extension WaypointVC: UITableViewDelegate {
    
}

extension WaypointVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}
