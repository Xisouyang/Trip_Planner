//
//  WaypointVC+Constraints.swift
//  Trip Planner
//
//  Created by Stephen Ouyang on 5/11/19.
//  Copyright © 2019 Stephen Ouyang. All rights reserved.
//

import Foundation

extension WaypointVC {
   
    func searchBarViewConstraints() {
        searchBarSubview.translatesAutoresizingMaskIntoConstraints = false
        searchBarSubview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        searchBarSubview.heightAnchor.constraint(equalToConstant: 65).isActive = true
        searchBarSubview.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 11).isActive = true
    }
    
    func tableViewConstraints() {
        
        waypointTableView.translatesAutoresizingMaskIntoConstraints = false
        waypointTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        waypointTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        waypointTableView.topAnchor.constraint(equalTo: searchBarSubview.bottomAnchor).isActive = true
    }
}
