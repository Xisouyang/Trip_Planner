//
//  Route.swift
//  Trip Planner
//
//  Created by Stephen Ouyang on 5/8/19.
//  Copyright © 2019 Stephen Ouyang. All rights reserved.
//

import Foundation

    let thePlist = Plist(name: "Info")
    let apiKey: String = thePlist?.getAPIKeyInPlistFile() as! String

    enum Router {
    case getPlaces

    var scheme: String {
        switch self {
        case .getPlaces:
            return "https"
        }
    }

    var host: String {
        switch self {
        case .getPlaces:
            return "maps.googleapis.com"
        }
    }

    var path: String {
        switch self {
        case .getPlaces:
            return "/maps/api/place/findplacefromtext/json"
        }
    }

    var method: String {
        switch self {
        case .getPlaces:
            return "GET"
        }
    }

    var parameters: [URLQueryItem] {
        let accessToken = apiKey
        switch self {
        case .getPlaces:
            return [URLQueryItem(name: "input", value: "San Francisco"),
                    URLQueryItem(name: "inputtype", value: "textquery"),
                    URLQueryItem(name: "fields", value: "name,geometry"),
                    URLQueryItem(name: "key", value: accessToken)]
        }
    }
}
