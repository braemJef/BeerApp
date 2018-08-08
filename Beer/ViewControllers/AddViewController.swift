//
//  AddViewController.swift
//  Beer
//
//  Created by Jef Braem on 07/08/2018.
//  Copyright © 2018 Jef Braem. All rights reserved.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController, UITextFieldDelegate {
    
    var editedBeer: Beer? = nil
    let realm = try! Realm()
    
    @IBOutlet weak var beerNameTextField: UITextField!
    @IBOutlet weak var beerBreweryTextField: UITextField!
    @IBOutlet weak var beerAlcoholTextField: UITextField!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beerAlcoholTextField.delegate = self
        
        if editedBeer != nil {
            navigationBar.title = "Edit"
            beerNameTextField.text = editedBeer?.Name
            beerBreweryTextField.text = editedBeer?.Brewery
            beerAlcoholTextField.text = editedBeer?.Alcohol
            print(editedBeer)
        } else {
            navigationBar.title = "Add"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        if editedBeer != nil {
            try! realm.write {
                editedBeer?.Name = beerNameTextField.text!
                editedBeer?.Brewery = beerBreweryTextField.text!
                editedBeer?.Alcohol = beerAlcoholTextField.text!
            }
        } else {
            let beer = Beer()
            beer.Name = beerNameTextField.text!
            beer.Brewery = beerBreweryTextField.text!
            beer.Alcohol = beerAlcoholTextField.text!
            try! realm.write {
                realm.add(beer)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        var currentText = textField.text!
        currentText = currentText.replacingOccurrences(of: ",", with: ".")
        var fullText = currentText
        fullText.append(string)
        
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.,")
        let characterSet = CharacterSet(charactersIn: fullText)
        let stringIsValid = allowedCharacters.isSuperset(of: characterSet)
        
        if !stringIsValid {
            return false
        }
        if fullText == "." {
            textField.text = "0."
            return false
        }
        let amount = fullText.components(separatedBy: ".")
        if amount.count > 2 {
            return false
        }
        if fullText.count == 2 {
            if fullText.prefix(1) == "0" {
                fullText = String(fullText.suffix(1))
                textField.text = fullText
                return false
            }
        }
        return true
    }
}
