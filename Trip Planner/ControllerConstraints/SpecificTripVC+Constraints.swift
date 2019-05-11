//
//  SpecificTripVC+Constraints.swift
//  Trip Planner
//
//  Created by Stephen Ouyang on 5/6/19.
//  Copyright © 2019 Stephen Ouyang. All rights reserved.
//

import Foundation

extension SpecificTripVC {
    
    func labelConstraints() {
        specificTripLabel.translatesAutoresizingMaskIntoConstraints = false
        specificTripLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        specificTripLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        specificTripLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func buttonConstraints() {
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        startButton.topAnchor.constraint(equalToSystemSpacingBelow: specificTripLabel.bottomAnchor, multiplier: 2).isActive = true
    }
}
