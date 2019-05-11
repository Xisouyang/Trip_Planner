//
//  ViewController.swift
//  Trip Planner
//
//  Created by Stephen Ouyang on 4/26/19.
//  Copyright © 2019 Stephen Ouyang. All rights reserved.
//

import UIKit

class PlannedTripVC: UIViewController {
    
    var tripTableView = UITableView(frame: .zero)
    let identifier = "cell"
    static var tripArr: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        setNav()
    }
    
    override func loadView() {
        super.loadView()
        setTableView()
    }
    
    func setNav() {
        navigationItem.title = "Planned Trips"
        navigationController?.navigationBar.backgroundColor = .lightGray
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    func setTableView() {
        
        view.addSubview(tripTableView)
        tripTableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        tripTableView.delegate = self
        tripTableView.dataSource = self
        tripTableViewConstraints()
    }
    
    @objc func addTapped() {
        let newVC = AddTripVC()
        navigationController?.pushViewController(newVC, animated: true)
    }
}

extension PlannedTripVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newVC = SpecificTripVC()
        SpecificTripVC.plannedTrip = PlannedTripVC.tripArr[indexPath.row]
        navigationController?.pushViewController(newVC, animated: true)
    }
}

extension PlannedTripVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlannedTripVC.tripArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = PlannedTripVC.tripArr[indexPath.row]
        return cell
    }
}

