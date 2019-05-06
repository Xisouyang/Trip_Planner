//
//  TripTableViewConstraints.swift
//  Trip Planner
//
//  Created by Stephen Ouyang on 4/26/19.
//  Copyright © 2019 Stephen Ouyang. All rights reserved.
//

import Foundation
import UIKit

extension PlannedTripVC {
    
    func tripTableViewConstraints() {
        tripTableView.translatesAutoresizingMaskIntoConstraints = false
        tripTableView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
        tripTableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
    }
}
