//
//  WaypointCell.swift
//  Trip Planner
//
//  Created by Stephen Ouyang on 5/14/19.
//  Copyright © 2019 Stephen Ouyang. All rights reserved.
//

import UIKit
import MapKit

class WaypointCell: UITableViewCell {
    
    static var identifier = "waypointCell"
    var waypoint: Waypoint?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
