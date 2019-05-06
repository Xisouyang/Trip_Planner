//
//  AddTripVC+Constraints.swift
//  Trip Planner
//
//  Created by Stephen Ouyang on 5/5/19.
//  Copyright © 2019 Stephen Ouyang. All rights reserved.
//

import Foundation

extension AddTripVC {
    
    func labelConstraints() {
        addTripLabel.translatesAutoresizingMaskIntoConstraints = false
        addTripLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addTripLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func textFieldConstraints() {
        addTripTextField.translatesAutoresizingMaskIntoConstraints = false
        addTripTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addTripTextField.topAnchor.constraint(equalToSystemSpacingBelow: addTripLabel.topAnchor, multiplier: 4).isActive = true
        addTripTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        addTripTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
