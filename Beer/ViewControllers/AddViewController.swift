//
//  AddViewController.swift
//  Beer
//
//  Created by Jef Braem on 07/08/2018.
//  Copyright © 2018 Jef Braem. All rights reserved.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController {
    
    let realm = try! Realm()
    
    @IBOutlet weak var beerNameTextField: UITextField!
    @IBOutlet weak var beerBreweryTextField: UITextField!
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        let beer = Beer()
        beer.Name = beerNameTextField.text!
        beer.Brewery = beerBreweryTextField.text!
        
        try! realm.write {
            realm.add(beer)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
