//
//  PlaceModel.swift
//  Trip Planner
//
//  Created by Stephen Ouyang on 5/10/19.
//  Copyright © 2019 Stephen Ouyang. All rights reserved.
//

import Foundation

struct PlaceModel: Codable {
    let candidates: [Candidate]
    let status: String
}

struct Candidate: Codable {
    let geometry: Geometry
    let name: String
}

struct Geometry: Codable {
    let location: Location
    let viewport: Viewport
}

struct Location: Codable {
    let lat, lng: Double
}

struct Viewport: Codable {
    let northeast, southwest: Location
}

