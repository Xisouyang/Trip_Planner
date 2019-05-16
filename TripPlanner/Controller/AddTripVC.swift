//
//  AddTripVCViewController.swift
//  Trip Planner
//
//  Created by Stephen Ouyang on 5/5/19.
//  Copyright © 2019 Stephen Ouyang. All rights reserved.
//

import UIKit

class AddTripVC: UIViewController {
    
    let manager = CoreDataManager.sharedManager
    
    var addTripLabel: UILabel = {
        let tripLabel = UILabel(frame: .zero)
        tripLabel.sizeToFit()
        tripLabel.text = "Give this trip a name!"
        return tripLabel
    }()
    
    var addTripTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 6
        textField.placeholder = "Sample Trip"
        return textField
    }()
    
    override func loadView() {
        super.loadView()
        setView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        view.backgroundColor = .white
        
        // Do any additional setup after loading the view.
    }
    
    func setNav() {
        navigationItem.title = "Add Trips"
        navigationController?.navigationBar.backgroundColor = .lightGray
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addTapped))
    }
    
    func setView() {
        view.addSubview(addTripLabel)
        view.addSubview(addTripTextField)
        labelConstraints()
        textFieldConstraints()
    }
    
    @objc func cancelTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addTapped() {
        let newVC = PlannedTripVC()
        guard let unwrappedText = addTripTextField.text else { return }
        
        if unwrappedText == "" {
            let alert = UIAlertController(title: "Must enter a trip name!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
        let newTrip = manager.createTrip(tripName: unwrappedText)
        PlannedTripVC.tripArr.append(newTrip as! Trip)
        navigationController?.initRootViewController(vc: newVC)
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
