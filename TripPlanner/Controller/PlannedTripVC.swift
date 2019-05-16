//
//  ViewController.swift
//  Trip Planner
//
//  Created by Stephen Ouyang on 4/26/19.
//  Copyright © 2019 Stephen Ouyang. All rights reserved.
//

import UIKit
import CoreData

class PlannedTripVC: UIViewController {
    
    var tripTableView = UITableView(frame: .zero)
    let identifier = "cell"
    static var tripArr: [Trip] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        setNav()
        print(PlannedTripVC.tripArr.first?.waypoints?.count)
    }
    
    override func loadView() {
        super.loadView()
        setTableView()
        PlannedTripVC.tripArr = CoreDataManager.sharedManager.fetchAllTrips() as! [Trip]
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
        newVC.plannedTrip = PlannedTripVC.tripArr[indexPath.row].name
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let object = PlannedTripVC.tripArr[indexPath.row]
            PlannedTripVC.tripArr.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            CoreDataManager.sharedManager.removeItem(objectID: object.objectID)
            CoreDataManager.sharedManager.saveContext()
        }
    }
}

extension PlannedTripVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlannedTripVC.tripArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = PlannedTripVC.tripArr[indexPath.row].name
        return cell
    }
}

