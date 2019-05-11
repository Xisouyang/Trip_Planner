//
//  WayPointVC.swift
//  Trip Planner
//
//  Created by Stephen Ouyang on 5/7/19.
//  Copyright © 2019 Stephen Ouyang. All rights reserved.
//

import UIKit

class WayPointVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        ServiceLayer.request(router: Router.getPlaces) { (result: Result<PlaceModel>) in
            print(result)
        }
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
