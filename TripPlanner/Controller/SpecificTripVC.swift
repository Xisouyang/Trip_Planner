//
//  SpecificTripVC.swift
//  Trip Planner
//
//  Created by Stephen Ouyang on 5/6/19.
//  Copyright © 2019 Stephen Ouyang. All rights reserved.
//

import UIKit

class SpecificTripVC: UIViewController {
    
    var plannedTrip: String?
    
    let specificTripLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.sizeToFit()
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "You haven't added any waypoints to your trip!"
        return label
    }()
    
    let startButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Add Waypoints", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setTitleColor(UIColor(red: 115/255, green: 194/255, blue: 251/255, alpha: 1.0), for: .highlighted)
        button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        return button
    }()

    override func loadView() {
        super.loadView()
        setView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNav()

        // Do any additional setup after loading the view.
    }
    
    func setView() {
        view.addSubview(specificTripLabel)
        view.addSubview(startButton)
        labelConstraints()
        buttonConstraints()
    }
    
    func setNav() {
        guard let unwrappedTitle = plannedTrip else { return }
        navigationItem.title = unwrappedTitle
        navigationController?.navigationBar.backgroundColor = .lightGray
    }
    
    @objc func cancelTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func addTapped() {
        let newVC = WaypointVC()
        newVC.plannedTrip = plannedTrip
        navigationController?.pushViewController(newVC, animated: true)
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
